//
//  SimilarTabContentView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 28.03.2025.
//

import UIKit
import SnapKit

final class SimilarTabContentCellViewModel: CellViewModelBaseClass {
    let media: [Media]
    let didTapAnyMedia: ((Media) -> Void)?
    private(set) var cellHeight: CGFloat = 1
    
    init(media: [Media], didTapAnyMedia: ((Media) -> Void)?) {
        self.media = media
        self.didTapAnyMedia = didTapAnyMedia
        super.init(cellIdentifier: "SimilarTabContentCell")
    }
    
    fileprivate func setCellHeight(to height: CGFloat) {
        self.cellHeight = height
    }
}

final class SimilarTabContentCell: ReusableCellBaseClass {
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let itemWidth = (UIConstants.screenWidth / 3) - 40
        static let itemHeight = itemWidth * 1.7
    }
    
    // MARK: - PROPERTIES
    private var viewModel: SimilarTabContentCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private lazy var gridCollectionView: DiffableCollectionView = {
        let view = DiffableCollectionView<Int, MediaPosterImageCellViewModel>(layout: createLayout())
        view.isScrollEnabled = false
        view.backgroundColor = CMColor.cmBackground
        view.register(cellClass: MediaPosterImageCell.self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureDataSource()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gridCollectionView.layoutIfNeeded()
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: SimilarTabContentCellViewModel) {
        self.viewModel = viewModel
        
        gridCollectionView.applySnapshot(
            sections: [0],
            itemsBySection: [
                0 : viewModel.media.map { MediaPosterImageCellViewModel(media: $0) }
            ]
        )
        
        gridCollectionView.performBatchUpdates(nil) { [weak self] _ in
            guard let self else { return }
            let height = self.gridCollectionView.contentSize.height
            viewModel.setCellHeight(to: height)
            self.invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(gridCollectionView)
        gridCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            let itemWidth = Constants.itemWidth
            let itemHeight = Constants.itemHeight
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(itemWidth), heightDimension: .absolute(itemHeight)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(itemHeight)), subitem: item, count: 3)
            group.interItemSpacing = .fixed(10)
            let vgroupHeight = itemHeight * 3 + 20
            let vgroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(vgroupHeight)), subitem: group, count: 3)
            vgroup.interItemSpacing = .fixed(10)
            return NSCollectionLayoutSection(group: vgroup)
        }
    }
    
    private func configureDataSource() {
        gridCollectionView.configureDataSource { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else { return UICollectionViewCell() }
            guard let media = self.viewModel?.media[safe: indexPath.item] else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaPosterImageCell.identifier, for: indexPath) as? MediaPosterImageCell
            let vm = MediaPosterImageCellViewModel(media: media, didTapMedia: viewModel?.didTapAnyMedia)
            cell?.configure(with: vm)
            return cell
        }
    }
}
