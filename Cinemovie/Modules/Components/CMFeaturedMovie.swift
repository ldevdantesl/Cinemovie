//
//  CMFeaturedMovie.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class CMFeaturedMovie: UIView {
    private let gradientLayer = CAGradientLayer()
    private let activityIndicatorImage = UIActivityIndicatorView(style: .large)
    
    private var changeMovieTimer: Timer?
    
    private var movies: [QueryMovie] = []
    
    private let movieImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    private let myListButton: CMButton = {
        let button = CMButton(
            text: "+ My List",
            foreColor: CMColor.cmLabel,
            textFont: CMFont.subtitleFont,
            backColor: CMColor.cmSecondary,
            cornerRadius: 10
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let watchListButton: CMButton = {
        let button = CMButton(
            text: "+ Watchlist",
            foreColor: .cmDivider,
            textFont: CMFont.subtitleFont,
            backColor: CMColor.cmLabel,
            cornerRadius: 10
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(movies: [QueryMovie]) {
        super.init(frame: .zero)
        self.movies = movies
        setupUI()
        setupGradient()
        updateMovie()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    // MARK: - PUBLIC FUNCTION
    func updateMovie() {
        guard let movie = movies.randomElement() else { return }
        if let url = ImagePathURLHelper.getImageURL(with: movie.posterPath, size: .w1280) {
            activityIndicatorImage.startAnimating()
            UIView.transition(with: movieImage, duration: 0.5, options: .transitionCrossDissolve) { [weak self] in
                self?.movieImage.sd_setImage(with: url)
            } completion: { [weak self] _ in
//                self?.animateScaling()
            }
        }
    }
    
    func updateMovies(_ movies: [QueryMovie]) {
        self.movies = movies
        updateMovie()
        startMovieChangeTimer()
    }
    
    func updateStretchEffect(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if offsetY < 0 {
            let scaleFactor = 1 + abs(offsetY) / 200
            movieImage.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        } else {
            movieImage.transform = .identity
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func startMovieChangeTimer() {
        changeMovieTimer?.invalidate()
        
        changeMovieTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateMovie()
        }
    }
    
    private func animateScaling() {
        UIView.animate(withDuration: 5.0, delay: 0, options: [.curveLinear, .autoreverse, .repeat]) { [weak self] in
            guard let self = self else { return }
            self.movieImage.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }
    
    private func setupUI() {
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderColor = CMColor.cmSecondary.cgColor
        layer.borderWidth = 0.3
        addSubview(activityIndicatorImage)
        activityIndicatorImage.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        addSubview(movieImage)
        movieImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let hstack = UIStackView(arrangedSubviews: [watchListButton, myListButton])
        hstack.axis = .horizontal
        hstack.spacing = 10
        hstack.alignment = .center
        hstack.distribution = .fill

        addSubview(hstack)
        hstack.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.black.withAlphaComponent(0.5).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 0.15, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        layer.insertSublayer(gradientLayer, above: movieImage.layer)
    }
}
