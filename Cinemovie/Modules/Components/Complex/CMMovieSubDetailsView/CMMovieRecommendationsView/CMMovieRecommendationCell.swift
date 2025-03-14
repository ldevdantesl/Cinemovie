//
//  CMMovieRecommendationCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 13.03.2025.
//

import UIKit
import SnapKit

final class CMMovieRecommendationCell: UICollectionViewCell {
 
    // MARK: - STATIC
    static let identifier = Constants.identifier
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let identifier = "CMMovieRecommendationCell"
        static let cornerRadius: CGFloat = 10
        static let indicatorSize: CGFloat = 20
    }
    
    // MARK: - PROPERTIES
    private lazy var moviePosterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        image.layer.cornerRadius = Constants.cornerRadius
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = CMColor.cmLabel
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    public func configure(with movie: QueryMovie) {
        if let imageURL = URLHelper.getImageURL(with: movie.posterPath, size: .w780) {
            loadingIndicator.startAnimating()
            moviePosterImageView.sd_setImage(with: imageURL) { _, _, _, _ in
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Private functions
    private func setupUI() {
        moviePosterImageView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(Constants.indicatorSize)
        }
        
        self.contentView.addSubview(moviePosterImageView)
        moviePosterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
