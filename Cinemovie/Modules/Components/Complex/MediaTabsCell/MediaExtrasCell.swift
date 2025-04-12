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
    let belongsToCollection: BelongsToCollection?
    let similar: [Media]
    let videos: [Video]
    let reviews: [Review]
    
    var didTapMedia: ((Media) -> Void)?
    
    init(
        seasons: [Season], belongsToCollection: BelongsToCollection?,
        similar: [Media], videos: [Video], reviews: [Review],
        didTapMedia: ((Media) -> Void)?
    ) {
        self.seasons = seasons
        self.belongsToCollection = belongsToCollection
        self.similar = similar
        self.videos = videos
        self.reviews = reviews
        self.didTapMedia = didTapMedia
        super.init(cellIdentifier: "MediaExtrasCell")
    }
}


final class MediaExtrasCell: ReusableCellBaseClass {
    private enum TabNames: String, CaseIterable {
        case similar = "Similar"
        case trailers = "Trailers"
    }
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let itemSpacing = 30.0
        static let spacing = 10.0
        static let tabsHeight = 50.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: MediaExtrasCellViewModel?
    private var items: [CellViewModelBaseClass] = []
    private var selectedTab: Int = -1
    
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
        view.register(MediaExtrasItemCell.self, forCellWithReuseIdentifier: MediaExtrasItemCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        
        let contentVM = items[safe: selectedTab]
        let contentHeight: CGFloat
        switch contentVM {
        case let vm as SimilarTabContentCellViewModel: contentHeight = vm.cellHeight
        case let vm as TrailersTabContentCellViewModel: contentHeight = vm.cellHeight
        default: contentHeight = 200
        }

        let totalHeight = Constants.tabsHeight + Constants.spacing + contentHeight
        layoutAttributes.frame.size.height = totalHeight
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
        self.items = []
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: MediaExtrasCellViewModel) {
        self.viewModel = viewModel
        
        let similarMedia = Array(viewModel.similar.prefix(9))
        let similarVM = SimilarTabContentCellViewModel(media: similarMedia, didTapAnyMedia: viewModel.didTapMedia)
        self.items.append(similarVM)
        
        let trailersMedia = viewModel.videos.filter { $0.type == .trailer }
        if !trailersMedia.isEmpty {
            let trailersVM = TrailersTabContentCellViewModel(trailers: trailersMedia)
            self.items.append(trailersVM)
        }
        self.layoutIfNeeded()
        switchTabs(to: 0)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(tabsCollectionView)
        tabsCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constants.tabsHeight).priority(.required)
        }
        
        tabsCollectionView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        tabsCollectionView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        addSubview(contentCollectionView)
        contentCollectionView.snp.makeConstraints {
            $0.top.equalTo(tabsCollectionView.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func createContentCollectionLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }
            let viewModel = self.items[safe: selectedTab]
            let height: CGFloat
            switch viewModel {
            case let vm as SimilarTabContentCellViewModel: height = vm.cellHeight
            case let vm as TrailersTabContentCellViewModel: height = vm.cellHeight
            default: height = 200
            }
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: item.layoutSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)

            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = Constants.spacing
            section.visibleItemsInvalidationHandler = { [weak self] item, offset, env in
                guard let self = self else { return }
                let page = Int(round(offset.x / environment.container.contentSize.width))
                guard page != self.selectedTab, self.items.indices.contains(page) else { return }
                
                self.selectedTab = page
                self.tabsCollectionView.reloadData()
                self.invalidateIntrinsicContentSize()
            }
            return section
        }
    }
    
    private func switchTabs(to index: Int) {
        guard index != selectedTab else { return }
        selectedTab = index
        tabsCollectionView.reloadData()
        contentCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
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
        switchTabs(to: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == contentCollectionView {
            let viewModel = items[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellIdentifier, for: indexPath)
            
            switch viewModel {
            case let vm as SimilarTabContentCellViewModel: (cell as? SimilarTabContentCell)?.configure(viewModel: vm)
            case let vm as TrailersTabContentCellViewModel: (cell as? TrailersTabContentCell)?.configure(viewModel: vm)
            default: break
            }
            
            return cell
        } else {
            let tab = TabNames.allCases[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaExtrasItemCell.identifier, for: indexPath) as? MediaExtrasItemCell else { return UICollectionViewCell() }
            cell.configure(text: tab.rawValue, isSelected: indexPath.row == selectedTab)
            return cell
        }
    }
}
