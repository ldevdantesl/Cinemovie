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
    
    init(media: [Media]) {
        self.media = media
        super.init(cellIdentifier: "SimilarTabContentCell")
    }
}

final class SimilarTabContentCell: UICollectionViewCell, ReusableCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants { }
    
    private enum Sections {
        case main
    }
    
    // MARK: - PROPERTIES
    private var viewModel: SimilarTabContentCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private lazy var gridCollectionView: DiffableCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 120, height: 180)
        
        let view = DiffableCollectionView<Sections, MediaPosterImageCellViewModel>(layout: layout)
        view.backgroundColor = CMColor.cmAccent
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
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: SimilarTabContentCellViewModel) {
        self.viewModel = viewModel
        gridCollectionView.applySnapshot(
            sections: [.main],
            itemsBySection: [
                .main : viewModel.media.map { MediaPosterImageCellViewModel(media: $0) }
            ]
        )
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
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/3), heightDimension: .absolute(100)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitem: item, count: 3)
            group.interItemSpacing = .fixed(10)
            
            let vgroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitem: group, count: 3)
            vgroup.interItemSpacing = .fixed(10)
            return NSCollectionLayoutSection(group: vgroup)
        }
    }
    
    private func configureDataSource() {
        gridCollectionView.configureDataSource { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else { return UICollectionViewCell() }
            guard let media = self.viewModel?.media[safe: indexPath.item] else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaPosterImageCell.identifier, for: indexPath) as? MediaPosterImageCell
            let vm = MediaPosterImageCellViewModel(media: media)
            cell?.configure(with: vm)
            return cell
        }
    }
}
