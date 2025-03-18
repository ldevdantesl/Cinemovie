//
//  CMMovieTitleAndOverviewCVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.03.2025.
//

import UIKit
import SnapKit

struct MovieTitleAndTaglineViewModel: MovieDetailsCellViewModel {
    let identifier: String = "MovieTitleAndTaglineView"
    
    let movieName: String
    let movieTagline: String
    
    init(movieName: String, movieTagline: String) {
        self.movieName = movieName
        self.movieTagline = CMTextFormatter.formatToCleanString(movieTagline)
    }
}

final class MovieTitleAndTaglineView: UICollectionViewCell {
    
    // MARK: - STATIC
    static let identifier = "MovieTitleAndTaglineView"
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let cinemovieLogoSize: CGFloat = 25
        static let spacer: CGFloat = 5
        static let biggerSpacing: CGFloat = 10
    }
    
    // MARK: - PROPERTIES
    private lazy var cinemovieLogoImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: ImageNames.logoAlt.rawValue))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var cinemovieLabel: UILabel = {
        let label = UILabel()
        label.text = "Cinemovie"
        label.font = CMFont.font(size: .caption, fontName: .avenirBold)
        label.textColor = CMColor.cmSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .body, fontName: .avenir)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieTaglineLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmSecondary
        label.font = CMFont.font(size: .footnote, fontName: .avenir)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
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
    public func configure(viewModel: MovieTitleAndTaglineViewModel) {
        movieNameLabel.text = viewModel.movieName
        movieTaglineLabel.text = viewModel.movieTagline
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        let hStack = UIStackView(arrangedSubviews: [cinemovieLogoImageView, cinemovieLabel, UIView()])
        hStack.axis = .horizontal
        hStack.spacing = 5
        hStack.alignment = .bottom
        hStack.distribution = .fill
        
        cinemovieLogoImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.cinemovieLogoSize)
        }
        
        addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        addSubview(movieNameLabel)
        movieNameLabel.snp.makeConstraints {
            $0.top.equalTo(hStack.snp.bottom).offset(Constants.spacer)
            $0.leading.trailing.equalToSuperview()
        }
        
        addSubview(movieTaglineLabel)
        movieTaglineLabel.snp.makeConstraints {
            $0.top.equalTo(movieNameLabel.snp.bottom).offset(Constants.spacer)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
