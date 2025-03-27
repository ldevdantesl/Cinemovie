//
//  CMMovieAddToWatchlistAndOverviewCVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.03.2025.
//

import UIKit
import SnapKit

struct WatchlistButtonCellViewModel: CellViewModel {
    let id: String = UUID().uuidString
    let cellIdentifier: String = "WatchlistButtonCell"
    static let absoluteCellHeight = 40.0
    
    init() { }
}

final class WatchlistButtonCell: UICollectionViewCell, ReusableCell {
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let imageName: String = "plus"
        static let buttonCornerRadius: CGFloat = 15
        static let buttonName = "Watchlist"
    }
    
    // MARK: - PROPERTIES
    private let addToWatchlistButton: CMButton = {
        let vm = CMButtonViewModel(
            text: Constants.buttonName, foreColor: .cmDivider,
            font: CMFont.font(size: .body, fontName: .avenirBold),
            image: UIImage(systemName: Constants.imageName),
            backColor: .cmLabel, cornerRadius: Constants.buttonCornerRadius
        )
        let button = CMButton(viewModel: vm)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(addToWatchlistButton)
        addToWatchlistButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
