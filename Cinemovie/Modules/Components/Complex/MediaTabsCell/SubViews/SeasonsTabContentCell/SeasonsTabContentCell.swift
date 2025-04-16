//
//  SeasonsTabContentCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 14.04.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class SeasonsTabContentCellViewModel: CellViewModelBaseClass {
    let seasons: [TVSeason]
    let onSeasonTap: ((TVSeason) -> Void)?
    let onHeightChangedRequest: (() -> Void)?
    private(set) var cellHeight: CGFloat = 100
    
    init(seasons: [TVSeason], onHeightChangedRequest: (() -> Void)?, onSeasonTap: ((TVSeason) -> Void)?) {
        self.seasons = seasons
        self.onHeightChangedRequest = onHeightChangedRequest
        self.onSeasonTap = onSeasonTap
        super.init(cellIdentifier: "SeasonsTabContentCell")
    }
    
    fileprivate func changeCellHeight(to height: CGFloat) {
        self.cellHeight = height
        self.onHeightChangedRequest?()
    }
}

final class SeasonsTabContentCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let itemSpacing = 10.0
        static let itemHeight = 120.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: SeasonsTabContentCellViewModel?
    private var items: [SeasonItemContentCellViewModel] = []
    
    // MARK: - VIEW PROPERTIES
    private lazy var seasonsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Constants.itemSpacing
        layout.itemSize = CGSize(width: UIConstants.screenWidth - 20, height: Constants.itemHeight)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(cellClass: SeasonItemContentCell.self)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = CMColor.cmBackground
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
    public func configure(viewModel: SeasonsTabContentCellViewModel) {
        self.viewModel = viewModel
        self.items = viewModel.seasons.map { SeasonItemContentCellViewModel(season: $0, didTapSeason: viewModel.onSeasonTap) }
        self.seasonsCollectionView.reloadData()
        viewModel.changeCellHeight(to: calculateCellHeight(totalItems: items.count))
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(seasonsCollectionView)
        seasonsCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func calculateCellHeight(totalItems: Int) -> CGFloat {
        return Double(totalItems) * (Constants.itemHeight + Constants.itemSpacing)
    }
}

extension SeasonsTabContentCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SeasonItemContentCell.identifier, for: indexPath
        ) as? SeasonItemContentCell else {
            return UICollectionViewCell()
        }
        
        let itemVM = items[indexPath.row]
        cell.configure(viewModel: itemVM)
        return cell
    }
}
