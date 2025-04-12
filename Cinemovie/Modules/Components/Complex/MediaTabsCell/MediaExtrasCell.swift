//
//  MediaTabsCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.03.2025.
//

import UIKit
import SnapKit

final class MediaExtrasCellViewModel: CellViewModelBaseClass {
    let seasons: [Season]
    let collectionDetails: BelongsToCollectionDetails?
    let similar: [Media]
    let videos: [Video]
    let reviews: [Review]
    
    var didTapMedia: ((Media) -> Void)?
    
    init(
        seasons: [Season], collectionDetails: BelongsToCollectionDetails?,
        similar: [Media], videos: [Video], reviews: [Review],
        didTapMedia: ((Media) -> Void)?
    ) {
        self.seasons = seasons
        self.collectionDetails = collectionDetails
        self.similar = similar
        self.videos = videos
        self.reviews = reviews
        self.didTapMedia = didTapMedia
        super.init(cellIdentifier: "MediaExtrasCell")
    }
}


final class MediaExtrasCell: ReusableCellBaseClass {
    // MARK: - OTHER
    private enum Tabs: CaseIterable {
        case seasons
        case collection
        case similar
        case trailers
        case reviews
        case none
        
        var title: String {
            switch self {
            case .seasons: "Seasons"
            case .collection: "Collection"
            case .similar: "Similar"
            case .trailers: "Trailers"
            case .reviews: "Reviews"
            case .none: ""
            }
        }
    }
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let itemSpacing = 30.0
        static let smallSpacing = 5.0
        static let spacing = 10.0
        static let tabsHeight = 50.0
        static let dividerHeight = 2.0
        static let dividerCornerRadius = 5.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: MediaExtrasCellViewModel?
    private var items: [Tabs : CellViewModelBaseClass] = [:]
    private var selectedTab: Tabs = .none
    private var visibleTabs: [Tabs] {
        return Tabs.allCases.filter { items[$0] != nil }
    }
    
    // MARK: - VIEW PROPERTIES
    private lazy var tabsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = Constants.itemSpacing
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = CMColor.cmBackground
        view.delegate = self
        view.dataSource = self
        view.register(MediaExtrasTabItemCell.self, forCellWithReuseIdentifier: MediaExtrasTabItemCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = CMColor.cmDivider
        divider.clipsToBounds = true
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    private lazy var contentCollectionView: UICollectionView = {
        let view = UICollectionView(frame:.zero, collectionViewLayout: createContentCollectionLayout())
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = CMColor.cmBackground
        view.register(SimilarTabContentCell.self, forCellWithReuseIdentifier: SimilarTabContentCell.identifier)
        view.register(TrailersTabContentCell.self, forCellWithReuseIdentifier: TrailersTabContentCell.identifier)
        view.register(BelongsToCollectionContentCell.self, forCellWithReuseIdentifier: BelongsToCollectionContentCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tabsCollectionView.layoutIfNeeded()
        contentCollectionView.layoutIfNeeded()
        dividerView.layer.cornerRadius = Constants.dividerCornerRadius
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        
        guard let contentVM = items[selectedTab] else {
            layoutAttributes.frame.size.height = Constants.tabsHeight + Constants.spacing + 210
            return layoutAttributes
        }
        
        let contentHeight: CGFloat
        switch contentVM {
        case let vm as SimilarTabContentCellViewModel: contentHeight = vm.cellHeight
        case let vm as TrailersTabContentCellViewModel: contentHeight = vm.cellHeight
        case let vm as BelongsToCollectionContentCellViewModel: contentHeight = vm.cellHeight
        default: contentHeight = 210
        }

        let totalHeight = Constants.tabsHeight + Constants.spacing + contentHeight + Constants.spacing
        layoutAttributes.frame.size.height = totalHeight
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
        self.items.removeAll()
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: MediaExtrasCellViewModel) {
        self.viewModel = viewModel
        
        if let collectionDetails = viewModel.collectionDetails {
            let belongsVM = BelongsToCollectionContentCellViewModel(collectionDetails: collectionDetails)
            self.items[.collection] = belongsVM
        }
        
        let similarMedia = Array(viewModel.similar.prefix(9))
        let similarVM = SimilarTabContentCellViewModel(media: similarMedia, didTapAnyMedia: viewModel.didTapMedia)
        self.items[.similar] = similarVM
        
        let trailersMedia = viewModel.videos.filter { $0.type == .trailer }
        if !trailersMedia.isEmpty {
            let trailersVM = TrailersTabContentCellViewModel(trailers: trailersMedia)
            self.items[.trailers] = trailersVM
        }
        self.layoutIfNeeded()
        
        guard let firstTab = items.keys.first else { return }
        selectedTab = firstTab
        self.switchTabs(to: firstTab, animated: false)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(tabsCollectionView)
        tabsCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constants.tabsHeight).priority(.required)
        }
        
        addSubview(dividerView)
        dividerView.snp.makeConstraints {
            $0.top.equalTo(tabsCollectionView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constants.dividerHeight)
        }
        
        addSubview(contentCollectionView)
        contentCollectionView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func createContentCollectionLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }
            
            let viewModel = self.items[selectedTab]
            let height: CGFloat
            switch viewModel {
            case let vm as SimilarTabContentCellViewModel: height = vm.cellHeight
            case let vm as TrailersTabContentCellViewModel: height = vm.cellHeight
            case let vm as BelongsToCollectionContentCellViewModel: height = vm.cellHeight
            default: height = 200
            }
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: item.layoutSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)

            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = Constants.spacing
            section.visibleItemsInvalidationHandler = { [weak self] _, offset, environment in
                guard let self = self else { return }
                let page = Int(round(offset.x / environment.container.contentSize.width))
                guard page < visibleTabs.count, let tab = visibleTabs[safe: page], tab != self.selectedTab else { return }
                self.selectedTab = tab
                self.tabsCollectionView.reloadData()
                self.invalidateIntrinsicContentSize()
            }
            return section
        }
    }
    
    private func switchTabs(to tab: Tabs, animated: Bool = true) {
        guard tab != selectedTab else { return }
        selectedTab = tab
        tabsCollectionView.reloadData()

        guard let index = visibleTabs.firstIndex(of: tab) else { return }
        contentCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)

        contentCollectionView.collectionViewLayout.invalidateLayout()
        invalidateIntrinsicContentSize()
        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension MediaExtrasCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == tabsCollectionView else { return }
        let tab = visibleTabs[indexPath.row]
        switchTabs(to: tab)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == contentCollectionView {
            let tab = visibleTabs[indexPath.row]
            guard let viewModel = items[tab] else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellIdentifier, for: indexPath)
            
            switch viewModel {
            case let vm as SimilarTabContentCellViewModel: (cell as? SimilarTabContentCell)?.configure(viewModel: vm)
            case let vm as TrailersTabContentCellViewModel: (cell as? TrailersTabContentCell)?.configure(viewModel: vm)
            case let vm as BelongsToCollectionContentCellViewModel: (cell as? BelongsToCollectionContentCell)?.configure(viewModel: vm)
            default: break
            }
            
            return cell
        } else {
            let tab = visibleTabs[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaExtrasTabItemCell.identifier, for: indexPath) as? MediaExtrasTabItemCell else { return UICollectionViewCell() }
            cell.configure(text: tab.title, isSelected: tab == selectedTab)
            return cell
        }
    }
}
