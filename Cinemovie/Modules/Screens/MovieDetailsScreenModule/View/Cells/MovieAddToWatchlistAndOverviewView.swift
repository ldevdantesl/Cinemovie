//
//  CMMovieAddToWatchlistAndOverviewCVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.03.2025.
//

import UIKit
import SnapKit

struct MovieAddToWatchlistAndOverviewViewModel: MovieDetailsCellViewModel {
    let identifier: String = "MovieAddToWatchlistAndOverviewView"
    let movieOverview: String
    
    init(movieOverview: String) {
        self.movieOverview = movieOverview
    }
    
    func didSelect() { }
}

final class MovieAddToWatchlistAndOverviewView: UICollectionViewCell {
    
    // MARK: - STATIC
    static let identifier = "MovieAddToWatchlistAndOverviewView"
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let imageName: String = "plus"
        static let buttonHeight: CGFloat = 40
        static let buttonCornerRadius: CGFloat = 15
        static let buttonName = "Watchlist"
        static let spacing: CGFloat = 10
    }
    
    // MARK: - PROPERTIES
    private lazy var movieOverviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = CMFont.font(size: .footnote, fontName: .avenir)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addToWatchlistButton: CMButton = {
        let button = CMButton(
            text: Constants.buttonName, foreColor: .cmDivider,
            textFont: CMFont.font(size: .body, fontName: .avenirBold), image: UIImage(systemName: Constants.imageName),
            backColor: .cmLabel, cornerRadius: Constants.buttonCornerRadius
        )
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
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: MovieAddToWatchlistAndOverviewViewModel) {
        movieOverviewLabel.text = viewModel.movieOverview
        layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(addToWatchlistButton)
        addToWatchlistButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.buttonHeight)
        }
        
        addSubview(movieOverviewLabel)
        movieOverviewLabel.snp.makeConstraints {
            $0.top.equalTo(addToWatchlistButton.snp.bottom).offset(Constants.spacing)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview().offset(-Constants.spacing)
        }
    }
}
