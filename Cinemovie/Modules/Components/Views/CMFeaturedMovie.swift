//
//  CMFeaturedMovie.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class CMFeaturedMovieViewModel {
    let movies: [QueryMovie]
    let changeInSeconds: TimeInterval
    let didTapMovie: ((QueryMovie) -> Void)?
    var currentMovie: QueryMovie?
    
    init(movies: [QueryMovie], changeInSeconds: TimeInterval = 5.0,didTapMovie: ((QueryMovie) -> Void)? = nil) {
        self.movies = movies
        self.changeInSeconds = changeInSeconds
        self.didTapMovie = didTapMovie
    }
}

final class CMFeaturedMovie: UIView {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let selfCornerRadius = 10.0
        static let selfBorderWidth = 0.3
        
        static let buttonCornerRadius = 10.0
        static let buttonSize = 40.0
        
        static let bigSpacing = 10.0
        
        static let stackHeight = 50.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: CMFeaturedMovieViewModel?
    private var movieWorkItem: DispatchWorkItem?
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - VIEW PROPERTIES
    private let loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.color = CMColor.cmLabel
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnMovieImage)))
        return image
    }()
    
    private let myListButton: CMButton = {
        let button = CMButton(
            text: "+ My List",
            foreColor: CMColor.cmLabel,
            textFont: CMFont.font(size: .subtitle),
            backColor: CMColor.cmSecondary,
            cornerRadius: Constants.buttonCornerRadius
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
            cornerRadius: Constants.buttonCornerRadius
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var hStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [myListButton, watchListButton])
        view.axis = .horizontal
        view.spacing = Constants.bigSpacing
        view.alignment = .center
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        clipsToBounds = true
        layer.cornerRadius = Constants.selfCornerRadius
        layer.borderColor = CMColor.cmSecondary.cgColor
        layer.borderWidth = Constants.selfBorderWidth
        applyGradientToImageView()
    }
    
    deinit {
        movieWorkItem?.cancel()
    }
    
    // MARK: - PUBLIC FUNCTION
    public func configure(viewModel: CMFeaturedMovieViewModel) {
        self.viewModel = viewModel
        startMovieLoop(movies: viewModel.movies)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        movieImage.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        addSubview(movieImage)
        movieImage.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.top.equalTo(movieImage.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constants.stackHeight)
        }
        
        myListButton.snp.makeConstraints {
            $0.size.equalTo(Constants.buttonSize)
        }
        
        watchListButton.snp.makeConstraints {
            $0.size.equalTo(Constants.buttonSize)
        }
    }
    
    private func startMovieLoop(movies: [QueryMovie]) {
        guard let viewModel = viewModel else { return }
        movieWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            guard let movie = movies.randomElement() else { return }
            self.viewModel?.currentMovie = movie
            self.updateMovie(with: movie)
            
            self.startMovieLoop(movies: movies)
        }
        movieWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + viewModel.changeInSeconds, execute: workItem)
    }
    
    private func updateMovie(with movie: QueryMovie) {
        if let url = URLHelper.getImageURL(with: movie.posterPath, size: .original) {
            loadingIndicator.startAnimating()
            movieImage.sd_setImage(with: url) { [weak self] _, _, _, _ in
                guard let self = self else { return }
                self.loadingIndicator.stopAnimating()
            }
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
    @objc private func didTapOnMovieImage() {
        guard let viewModel = viewModel else { return }
        guard let currentMovie = viewModel.currentMovie else { return }
        viewModel.didTapMovie?(currentMovie)
    }
}
