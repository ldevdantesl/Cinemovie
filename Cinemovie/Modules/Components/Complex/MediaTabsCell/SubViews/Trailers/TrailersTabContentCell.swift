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
    let cellHeight: CGFloat
    
    init(trailers: [Video]) {
        self.trailers = trailers
        self.cellHeight = CGFloat(trailers.count * 240)
        super.init(cellIdentifier: "TrailersTabContentCell")
    }
}

final class TrailersTabContentCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants { }
    
    // MARK: - PROPERTIES
    private var viewModel: TrailersTabContentCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private lazy var trailersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.itemSize = .init(width: UIConstants.screenWidth - 20, height: 230)
        
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
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: TrailersTabContentCellViewModel) {
        self.viewModel = viewModel
        trailersCollectionView.reloadData()
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
        return viewModel?.trailers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel, let trailer = viewModel.trailers[safe: indexPath.row] else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaTrailerCell.identifier, for: indexPath) as? MediaTrailerCell else { return UICollectionViewCell() }
        let trailerViewModel = MediaTrailerCellViewModel(trailer: trailer)
        cell.configure(viewModel: trailerViewModel)
        return cell
    }
}
