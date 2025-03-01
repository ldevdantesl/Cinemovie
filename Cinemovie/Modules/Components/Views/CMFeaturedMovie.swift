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
    private var didTapMovie: ((QueryMovie) -> Void)?
    
    private var gradientLayer: CAGradientLayer?
    private let activityIndicatorImage = UIActivityIndicatorView(style: .large)
    
    private var changeMovieTimer: Timer?
    
    private var movies: [QueryMovie] = []
    private var currentMovie: QueryMovie?
    
    private let buttonsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var movieImage: UIImageView = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapedOnMovieImage))
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(gesture)
        return image
    }()
    
    private let myListButton: CMButton = {
        let button = CMButton(
            text: "+ My List",
            foreColor: CMColor.cmLabel,
            textFont: CMFont.font(size: .subtitle),
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
            textFont: CMFont.font(size: .subtitle),
            backColor: CMColor.cmLabel,
            cornerRadius: 10
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(movies: [QueryMovie], didTapMovie: @escaping (QueryMovie) -> Void) {
        super.init(frame: .zero)
        self.movies = movies
        self.didTapMovie = didTapMovie
        setupUI()
        updateMovie()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        changeMovieTimer?.invalidate()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradientToImageView()
    }
    
    // MARK: - PUBLIC FUNCTION
    func updateMovie() {
        guard let movie = movies.randomElement() else { return }
        self.currentMovie = movie
        if let url = URLHelper.getImageURL(with: movie.posterPath, size: .w1280) {
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
    
    // MARK: - PRIVATE FUNCTIONS
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
    
    private func startMovieChangeTimer() {
        changeMovieTimer?.invalidate()
        changeMovieTimer = nil
        
        changeMovieTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateMovie()
        }
    }
    
    private func applyGradientToImageView() {
        if gradientLayer == nil {
            let newGradientLayer = CAGradientLayer()
            newGradientLayer.colors = [
                UIColor.black.cgColor,
                UIColor.clear.cgColor
            ]
            newGradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
            newGradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
            movieImage.layer.insertSublayer(newGradientLayer, at: 0)
            gradientLayer = newGradientLayer
        }
        
        gradientLayer?.frame = CGRect(
            x: 0,
            y: movieImage.bounds.height * 0.8,
            width: movieImage.bounds.width,
            height: movieImage.bounds.height * 0.2
        )
    }
    
    // MARK: - OBJC FUNCTIONS
    @objc
    private func didTapedOnMovieImage() {
        guard let currentMovie = currentMovie else { return }
        didTapMovie?(currentMovie)
    }
}
