//
//  TrailersTabContentCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.04.2025.
//

import UIKit
import SnapKit

final class TrailersTabContentCellViewModel: CellViewModelBaseClass {
    let trailers: [Video]
    private(set) var cellHeight: CGFloat = 100.0
    
    init(trailers: [Video]) {
        self.trailers = trailers
        super.init(cellIdentifier: "TrailersTabContentCell")
    }
    
    fileprivate func setCellHeight(to height: CGFloat) {
        self.cellHeight = height
    }
}

final class TrailersTabContentCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let itemHeight = 230.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: TrailersTabContentCellViewModel?
    private var items: [MediaTrailerCellViewModel] = []
    
    // MARK: - VIEW PROPERTIES
    private lazy var trailersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.itemSize = .init(width: UIConstants.screenWidth - 20, height: Constants.itemHeight)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(MediaTrailerCell.self, forCellWithReuseIdentifier: MediaTrailerCell.identifier)
        view.dataSource = self
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
        let totalTrailers = CGFloat(viewModel?.trailers.count ?? 2)
        let height = Constants.itemHeight * totalTrailers
        layoutAttributes.frame.size.height = height
        self.viewModel?.setCellHeight(to: height)
        return layoutAttributes
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: TrailersTabContentCellViewModel) {
        self.viewModel = viewModel
        self.items = viewModel.trailers.map { MediaTrailerCellViewModel(trailer: $0) }
        trailersCollectionView.reloadData()
        layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(trailersCollectionView)
        trailersCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}

extension TrailersTabContentCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MediaTrailerCell.identifier, for: indexPath
        ) as? MediaTrailerCell else { return UICollectionViewCell() }
        let itemVM = items[indexPath.row]
        cell.configure(viewModel: itemVM)
        return cell
    }
}
