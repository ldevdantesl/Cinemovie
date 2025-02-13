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
    private let activityIndicatorImage = UIActivityIndicatorView(style: .large)
    
    private var changeMovieTimer: Timer?
    
    private var movies: [QueryMovie] = []
    
    private let buttonsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private let movieImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
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
        updateMovie()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradientToImageView()
    }
    
    // MARK: - PUBLIC FUNCTION
    func updateMovie() {
        guard let movie = movies.randomElement() else { return }
        if let url = ImagePathURLHelper.getImageURL(with: movie.posterPath, size: .w1280) {
            activityIndicatorImage.startAnimating()
            UIView.transition(with: movieImage, duration: 0.5, options: .transitionCrossDissolve) { [weak self] in
                self?.movieImage.sd_setImage(with: url)
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
            $0.top.leading.trailing.equalToSuperview()
        }
        
        
        addSubview(buttonsContainer)
        buttonsContainer.snp.makeConstraints {
            $0.top.equalTo(movieImage.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        buttonsContainer.addSubview(watchListButton)
        
        watchListButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().multipliedBy(0.48)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        buttonsContainer.addSubview(myListButton)
        
        myListButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(watchListButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func applyGradientToImageView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.clear.cgColor
        ]
        
        let gradientHeight = movieImage.bounds.height * 0.2
        
        gradientLayer.frame = CGRect(x: 0, y: movieImage.bounds.height - gradientHeight, width: movieImage.bounds.width, height: gradientHeight)
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)

        movieImage.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        movieImage.layer.insertSublayer(gradientLayer, at: 0)
    }
}
