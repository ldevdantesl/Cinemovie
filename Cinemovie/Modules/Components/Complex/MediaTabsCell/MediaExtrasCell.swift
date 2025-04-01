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
    
    init(seasons: [Season], belongsToCollection: BelongsToCollection?, similar: [Media], videos: [Video], reviews: [Review]) {
        self.seasons = seasons
        self.belongsToCollection = belongsToCollection
        self.similar = similar
        self.videos = videos
        self.reviews = reviews
        super.init(cellIdentifier: "MediaExtrasCell")
    }
}


final class MediaExtrasCell: UICollectionViewCell, ReusableCell {
    private enum TabNames: String, CaseIterable {
        case similar = "Similar"
    }
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let itemSpacing = 30.0
        static let spacing = 10.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: MediaExtrasCellViewModel?
    private var items: [CellViewModelBaseClass] = []
    private var tabItems: [Int : CellViewModelBaseClass] = [:]
    private var selectedTab: Int = 0
    
    // MARK: - VIEW PROPERTIES
    private lazy var tabsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = Constants.itemSpacing
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.register(MediaExtrasItemCell.self, forCellWithReuseIdentifier: MediaExtrasItemCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(405)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(405)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            return section
        }
        
        let view = UICollectionView(frame:.zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.register(SimilarTabContentCell.self, forCellWithReuseIdentifier: SimilarTabContentCell.identifier)
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
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: MediaExtrasCellViewModel) {
        self.viewModel = viewModel
        let similarVM = SimilarTabContentCellViewModel(media: viewModel.similar)
        self.items = [similarVM]
        self.tabItems = [0 : similarVM]
        contentCollectionView.reloadData()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(tabsCollectionView)
        tabsCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        addSubview(contentCollectionView)
        contentCollectionView.snp.makeConstraints {
            $0.top.equalTo(tabsCollectionView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension MediaExtrasCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == contentCollectionView {
            let viewModel = items[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellIdentifier, for: indexPath)
            
            switch viewModel {
            case let vm as SimilarTabContentCellViewModel: (cell as? SimilarTabContentCell)?.configure(viewModel: vm)
            default: break
            }
            
            return cell
        } else {
            let text = TabNames.allCases[indexPath.row].rawValue
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaExtrasItemCell.identifier, for: indexPath) as? MediaExtrasItemCell else { return UICollectionViewCell() }
            cell.configure(text: text, isSelected: indexPath.row == selectedTab)
            return cell
        }
    }
}
