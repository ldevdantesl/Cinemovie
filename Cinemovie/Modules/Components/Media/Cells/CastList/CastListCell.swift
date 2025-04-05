//
//  CMMovieCastList.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.02.2025.
//

import UIKit
import SnapKit

final class CastListCellViewModel: CellViewModelBaseClass {
    let cast: [Cast]
    let didSelectCast: ((Cast) -> Void)?
    static let cellHeight = 130.0
    
    init(cast: [Cast], didSelectCast: ((Cast) -> Void)?) {
        self.cast = cast
        self.didSelectCast = didSelectCast
        super.init(cellIdentifier: "CastListCell")
    }
}

final class CastListCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing: CGFloat = 5
        static let biggerSpacing = 10.0
        static let hSpacing: CGFloat = 15
        static let itemWidth = 80.0
        static let itemHeight = 105.0
    }
    
    enum CastListSection: Hashable {
        case main
    }

    // MARK: - PROPERTIES
    private var viewModel: CastListCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let castLabel: UILabel = {
        let label = UILabel()
        label.text = "Cast"
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.textColor = CMColor.cmSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: DiffableCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.hSpacing
        layout.itemSize = CGSize(width: Constants.itemWidth, height: Constants.itemHeight)
        
        let cv = DiffableCollectionView<CastListSection, CastListItemCellViewModel>(layout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = CMColor.cmBackground
        cv.register(cellClass: CastListItemCell.self)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
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
    
    // MARK: - PUBLIC FUNCTIONS
    public func configure(viewModel: CastListCellViewModel) {
        self.viewModel = viewModel
        self.collectionView.applySnapshot(
            sections: [.main],
            itemsBySection: [.main: viewModel.cast.map { CastListItemCellViewModel(cast: $0, didTapCast: viewModel.didSelectCast) }]
        )
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        self.addSubview(castLabel)
        castLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(castLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, viewModel in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastListItemCell.identifier, for: indexPath) as? CastListItemCell
            cell?.configure(viewModel: viewModel)
            return cell
        }
    }
}
