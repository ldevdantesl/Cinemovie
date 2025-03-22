//
//  CMMovieAddToWatchlistAndOverviewCVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.03.2025.
//

import UIKit
import SnapKit

class MovieDetailsWatchlistOverviewViewModel: MovieDetailsCellViewModel {
    let identifier: String = "MovieDetailsWatchlistOverviewView"
    let movieOverview: String
    var cellHeight: CGFloat = 80.0
    
    init(movieOverview: String) {
        self.movieOverview = movieOverview
    }
}

final class MovieDetailsWatchlistOverviewView: UICollectionViewCell {
    
    // MARK: - STATIC
    static let identifier = "MovieDetailsWatchlistOverviewView"
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let imageName: String = "plus"
        static let buttonHeight: CGFloat = 40
        static let buttonCornerRadius: CGFloat = 15
        static let buttonName = "Watchlist"
        static let spacing: CGFloat = 10
    }
    
    // MARK: - PROPERTIES
    private let addToWatchlistButton: CMButton = {
        let button = CMButton(
            text: Constants.buttonName, foreColor: .cmDivider,
            textFont: CMFont.font(size: .body, fontName: .avenirBold), image: UIImage(systemName: Constants.imageName),
            backColor: .cmLabel, cornerRadius: Constants.buttonCornerRadius
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let movieOverviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = CMFont.font(size: .footnote, fontName: .avenirDemiBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [addToWatchlistButton, movieOverviewLabel])
        stack.axis = .vertical
        stack.spacing = Constants.spacing
        stack.alignment = .fill
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    public func configure(viewModel: MovieDetailsWatchlistOverviewViewModel) {
        movieOverviewLabel.text = viewModel.movieOverview

        let targetWidth = contentView.frame.width
        
        let fittingSize = CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height)
        let calculatedHeight = vStack.systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        
        viewModel.cellHeight = calculatedHeight
        self.layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addToWatchlistButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(Constants.buttonHeight)
        }
    }
}
