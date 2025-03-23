//
//  CMMovieListCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import SnapKit
import UIKit

struct CMMediaListViewCellViewModel {
    private(set) var isMovieMedia: Bool
    let movie: Movie?
    let tvShow: TVSeries?
    
    init(movie: Movie) {
        self.isMovieMedia = true
        self.movie = movie
        self.tvShow = nil
    }
    
    init(tvShow: TVSeries) {
        self.isMovieMedia = false
        self.movie = nil
        self.tvShow = tvShow
    }
}

final class CMMediaListViewCell: UICollectionViewCell {
    // MARK: - STATIC
    static let identifier = "CMMediaListViewCell"
    
    // MARK: - PROPERTIES
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let mediaImageView: UIImageView = {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mediaImageView.layer.cornerRadius = 10
    }
    
    // MARK: - PUBLIC FUNC
    func configure(viewModel: CMMediaListViewCellViewModel) {
        let posterPath: String?
        switch viewModel.isMovieMedia {
        case true:
            guard let movie = viewModel.movie else { return }
            posterPath = movie.posterPath
        case false:
            guard let tvShow = viewModel.tvShow else { return }
            posterPath = tvShow.posterPath
        }
        
        guard let url = URLHelper.getImageURL(with: posterPath, size: .w780) else { return }
        
        loadingIndicator.startAnimating()
        mediaImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
            self?.loadingIndicator.stopAnimating()
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(mediaImageView)
        mediaImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mediaImageView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(50)
        }
    }
}
