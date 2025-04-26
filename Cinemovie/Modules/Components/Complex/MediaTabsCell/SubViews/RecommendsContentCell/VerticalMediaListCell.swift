//
//  RecommendsContentCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 14.04.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class VerticalMediaListCellViewModel: CellViewModelBaseClass, CellWithHeightProtocol {
    let recommendedMedia: [Media]
    let didTapAnyMedia: ((Media) -> Void)?
    var cellHeight: CGFloat = 100
    
    init(recommendedMedia: [Media], didTapAnyMedia: ((Media) -> Void)?) {
        self.recommendedMedia = recommendedMedia
        self.didTapAnyMedia = didTapAnyMedia
        super.init(cellIdentifier: "VerticalMediaListCell")
    }
    
    func setCellHeight(to height: CGFloat) {
        self.cellHeight = height
    }
}

final class VerticalMediaListCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let itemWidth = (UIConstants.screenWidth / 3) - 40
        static let itemHeight = itemWidth * 1.7
        static let vGroupHeight = itemHeight * 3 + 20
        static let vSpacing = 10.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: VerticalMediaListCellViewModel?
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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let height = gridCollectionView.contentSize.height
        layoutAttributes.frame.size.height = height
        self.viewModel?.setCellHeight(to: height)
        return layoutAttributes
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: VerticalMediaListCellViewModel) {
        self.viewModel = viewModel
        self.items = viewModel.recommendedMedia.map { MediaPosterImageCellViewModel(media: $0, didTapMedia: viewModel.didTapAnyMedia) }
        self.gridCollectionView.reloadData()
        self.layoutIfNeeded()
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
            group.interItemSpacing = .fixed(Constants.vSpacing)
            let vgroupHeight = Constants.vGroupHeight
            let vgroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(vgroupHeight)), subitem: group, count: 3)
            vgroup.interItemSpacing = .fixed(Constants.vSpacing)
            let section = NSCollectionLayoutSection(group: vgroup)
            section.interGroupSpacing = Constants.vSpacing
            return section
        }
    }
}

extension VerticalMediaListCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MediaPosterImageCell.identifier, for: indexPath
        ) as? MediaPosterImageCell else { return UICollectionViewCell() }
        let vm = items[indexPath.row]
        cell.configure(with: vm)
        return cell
    }
}
