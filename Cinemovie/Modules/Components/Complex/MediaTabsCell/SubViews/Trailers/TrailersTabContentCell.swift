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
    
    init(trailers: [Video]) {
        self.trailers = trailers
        super.init(cellIdentifier: "TrailersTabContentCell")
    }
}

final class TrailersTabContentCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants { }
    
    // MARK: - PROPERTIES
    private var viewModel: TrailersTabContentCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private var trailersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.itemSize = .init(width: UIConstants.screenWidth, height: 100)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
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
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(trailersCollectionView)
        trailersCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
