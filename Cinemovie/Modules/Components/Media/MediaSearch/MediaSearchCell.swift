//
//  MediaSearchCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 25.04.2025.
//

import UIKit
import SnapKit

final class MediaSearchCellViewModel: CellViewModelBaseClass {
    let movies: [Movie]
    let tvSeries: [TVSeries]
    let people: [Person]
    let didTapAnyMedia: ((Media) -> Void)?
    let didTriggerPagination: ((MediaTypes) -> Void)?
    
    init(movies: [Movie], tvSeries: [TVSeries], people: [Person], didTapAnyMedia: ((Media) -> Void)?, didTriggerPagination: ((MediaTypes) -> Void)?) {
        self.movies = movies
        self.tvSeries = tvSeries
        self.people = people
        self.didTriggerPagination = didTriggerPagination
        self.didTapAnyMedia = didTapAnyMedia
        super.init(cellIdentifier: "MediaSearchCell")
    }
}

final class MediaSearchCell: ReusableCellBaseClass {
    // MARK: - TYPEALIAS
    typealias CellVMs = CellViewModelBaseClass & CellWithHeightProtocol
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let tabsSpacing = 10.0
        static let spacing = 10.0
        static let defaultCellHeight: CGFloat = 200.0
        static let tabsHeight = 50.0
    }
    
    fileprivate enum Tabs: CaseIterable {
        case movies
        case tvSeries
        case people
        case none
        
        var title: String {
            switch self {
            case .movies: return "Movies"
            case .tvSeries: return "TV Series"
            case .people: return "People"
            case .none: return ""
            }
        }
        
        var mediaType: MediaTypes {
            switch self {
            case .movies: return .movie
            case .tvSeries: return .tvShow
            default: return .movie
            }
        }
    }
    
    // MARK: - PROPERTIES
    private var viewModel: MediaSearchCellViewModel?
    private var selectedTab: Tabs = .none
    private var items: [Tabs : CellVMs] = [:]
    private var visibleTabs: [Tabs] {
        return Tabs.allCases.filter { items[$0] != nil }
    }
    private var didTriggerPagination = false
    
    // MARK: - VIEW PROPERTIES
    private lazy var tabsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.tabsSpacing
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = CMColor.cmBackground
        view.register(cellClass: TabItemCell.self)
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = CMColor.cmBackground
        view.register(cellClass: VerticalMediaListCell.self)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        searchCollectionView.layoutIfNeeded()
        
        guard let contentVM = items[selectedTab] else {
            layoutAttributes.frame.size.height = tabsCollectionView.contentSize.height + Constants.defaultCellHeight + Constants.spacing
            return layoutAttributes
        }
        
        layoutAttributes.frame.size.height = max((tabsCollectionView.contentSize.height + contentVM.cellHeight + Constants.spacing), UIConstants.screenHeight / 2)
        return layoutAttributes
    }
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        items.removeAll()
        selectedTab = .none
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: MediaSearchCellViewModel) {
        self.viewModel = viewModel
        if !viewModel.movies.isEmpty {
            let vm = VerticalMediaListCellViewModel(media: viewModel.movies, didTapAnyMedia: viewModel.didTapAnyMedia) { [weak self] in
                guard let self = self else { return }
                if self.selectedTab == .movies {
                    viewModel.didTriggerPagination?(.movie)
                }
            } onHeightChangedRequest: { [weak self] in
                self?.onHeightChangedRequest()
            }
            items[.movies] = vm
        }

        if !viewModel.tvSeries.isEmpty {
            let vm = VerticalMediaListCellViewModel(media: viewModel.tvSeries, didTapAnyMedia: viewModel.didTapAnyMedia) { [weak self] in
                guard let self = self else { return }
                if self.selectedTab == .tvSeries {
                    viewModel.didTriggerPagination?(.tvShow)
                }
            } onHeightChangedRequest: { [weak self] in
                self?.onHeightChangedRequest()
            }
            items[.tvSeries] = vm
        }
        
        guard let firstTab = items.keys.first else { return }
        DispatchQueue.main.async {
            self.selectedTab = firstTab
            self.switchTabs(to: firstTab, animated: false)
            self.searchCollectionView.reloadData()
            self.searchCollectionView.performBatchUpdates(nil)
            self.invalidateIntrinsicContentSize()
            self.layoutIfNeeded()
        }
    }
    
    public func didRecieveNewSearchResults(media: [Media], forType type: MediaTypes) {
        let tabToUpdate: Tabs
        switch type {
        case .movie: tabToUpdate = .movies
        case .tvShow: tabToUpdate = .tvSeries
        }
        
        guard let tabIndex = visibleTabs.firstIndex(of: tabToUpdate) else { return }
        let indexPath = IndexPath(item: tabIndex, section: 0)
        guard let cell = searchCollectionView.cellForItem(at: indexPath) as? VerticalMediaListCell else { return }
        cell.reloadData(withNewItems: media)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(tabsCollectionView)
        tabsCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constants.tabsHeight).priority(.required)
        }

        addSubview(searchCollectionView)
        searchCollectionView.snp.makeConstraints {
            $0.top.equalTo(tabsCollectionView.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func switchTabs(to tab: Tabs, animated: Bool = true) {
        guard tab != selectedTab else { return }
        selectedTab = tab
        tabsCollectionView.reloadData()

        guard let index = visibleTabs.firstIndex(of: tab) else { return }
        searchCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            guard let self = self else { return nil }
            let vm = self.items[selectedTab]
            let cellHeight = max((vm?.cellHeight ?? Constants.defaultCellHeight), UIConstants.screenHeight / 2)
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(cellHeight)))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: item.layoutSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = Constants.tabsSpacing
            section.visibleItemsInvalidationHandler = { [weak self] _, offset, environment in
                guard let self = self else { return }
                let page = Int(round(offset.x / environment.container.contentSize.width))
                guard page < visibleTabs.count, let tab = visibleTabs[safe: page], tab != self.selectedTab else { return }
                self.selectedTab = tab
                self.tabsCollectionView.reloadData()
                self.searchCollectionView.invalidateIntrinsicContentSize()
                self.invalidateIntrinsicContentSize()
            }
            return section
        }
    }
    
    private func onHeightChangedRequest() {
        self.searchCollectionView.collectionViewLayout.invalidateLayout()
        self.invalidateIntrinsicContentSize()
    }
}

extension MediaSearchCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tab = visibleTabs[indexPath.row]
        guard collectionView == searchCollectionView else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabItemCell.identifier, for: indexPath) as? TabItemCell else { return UICollectionViewCell() }
            let vm = TabItemCellViewModel(text: tab.title, font: CMFont.font(size: .caption, fontName: .avenirBold), isSelected: tab == selectedTab, isCapsuled: true)
            cell.configure(viewModel: vm)
            return cell
        }
        
        guard let viewModel = items[tab] else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellIdentifier, for: indexPath)
        
        switch viewModel {
        case let vm as VerticalMediaListCellViewModel: (cell as? VerticalMediaListCell)?.configure(viewModel: vm)
        default: break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == tabsCollectionView else { return }
        let tab = visibleTabs[indexPath.row]
        switchTabs(to: tab)
    }
}
