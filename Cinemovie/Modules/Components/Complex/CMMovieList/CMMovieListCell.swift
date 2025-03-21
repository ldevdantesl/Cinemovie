//
//  CMMovieListCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import SnapKit
import UIKit

final class CMMovieListCell: UICollectionViewCell {
    // MARK: - STATIC
    static let identifier = "CMMovieListCell"
    
    // MARK: - PROPERTIES
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let movieImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = CMColor.cmSecondaryBackground
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
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
    func configure(movie: QueryMovie) {
        if let url = URLHelper.getImageURL(with: movie.posterPath, size: .w780) {
            loadingIndicator.startAnimating()
            movieImage.sd_setImage(with: url) { [weak self] _, _, _, _ in
                self?.loadingIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(movieImage)
        movieImage.layer.cornerRadius = 10
        movieImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        movieImage.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(50)
        }
    }
}
