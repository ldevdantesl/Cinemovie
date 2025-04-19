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
    private var items: [MediaPosterImageCellViewModel] = []
    
    // MARK: - VIEW PROPERTIES
    private lazy var gridCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.isScrollEnabled = false
        view.dataSource = self
        view.backgroundColor = CMColor.cmBackground
        view.register(cellClass: MediaPosterImageCell.self)
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
        gridCollectionView.layoutIfNeeded()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let height = self.gridCollectionView.contentSize.height
        layoutAttributes.frame.size.height = height
        return layoutAttributes
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: SimilarTabContentCellViewModel) {
        self.viewModel = viewModel
        self.items = viewModel.media.map { MediaPosterImageCellViewModel(media: $0, didTapMedia: viewModel.didTapAnyMedia) }
        self.gridCollectionView.reloadData()
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
}

extension SimilarTabContentCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MediaPosterImageCell.identifier, for: indexPath
        ) as? MediaPosterImageCell else { return UICollectionViewCell() }
        let itemVM = items[indexPath.row]
        cell.configure(with: itemVM)
        return cell
    }
    
}
