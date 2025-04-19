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
    private(set) var cellHeight: CGFloat = 100
    
    init(seasons: [TVSeason], onSeasonTap: ((TVSeason) -> Void)?) {
        self.seasons = seasons
        self.onSeasonTap = onSeasonTap
        super.init(cellIdentifier: "SeasonsTabContentCell")
    }
    
    fileprivate func setCellHeight(to height: CGFloat) {
        self.cellHeight = height
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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let height = seasonsCollectionView.contentSize.height
        layoutAttributes.frame.size.height = height
        self.viewModel?.setCellHeight(to: height)
        return layoutAttributes
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: SeasonsTabContentCellViewModel) {
        self.viewModel = viewModel
        self.items = viewModel.seasons.map { SeasonItemContentCellViewModel(season: $0, didTapSeason: viewModel.onSeasonTap) }
        self.seasonsCollectionView.reloadData()
        self.layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(seasonsCollectionView)
        seasonsCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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
