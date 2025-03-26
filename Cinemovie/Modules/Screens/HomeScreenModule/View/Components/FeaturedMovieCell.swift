//
//  CMFeaturedMovie.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class FeaturedMovieCellViewModel: CellViewModel, Hashable {
    let id = UUID()
    var cellIdentifier: String = "FeaturedMovieCell"
    let movies: [Movie]
    let changeInSeconds: TimeInterval
    let didTapMovie: ((Movie) -> Void)?
    var currentMovie: Movie?
    
    init(movies: [Movie], changeInSeconds: TimeInterval = 5.0,didTapMovie: ((Movie) -> Void)? = nil) {
        self.movies = movies
        self.changeInSeconds = changeInSeconds
        self.didTapMovie = didTapMovie
    }
    
    static func == (lhs: FeaturedMovieCellViewModel, rhs: FeaturedMovieCellViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class FeaturedMovieCell: UICollectionViewCell, ReusableCell {
    typealias ViewModel = FeaturedMovieCellViewModel
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let selfCornerRadius = 10.0
        static let selfBorderWidth = 0.3
        
        static let buttonCornerRadius = 10.0
        static let buttonSize = 40.0
        
        static let bigSpacing = 10.0
        
        static let stackHeight = 70.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: FeaturedMovieCellViewModel?
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
    public func configure(with viewModel: FeaturedMovieCellViewModel) {
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
            $0.edges.equalToSuperview()
        }
    }
    
    private func startMovieLoop(movies: [Movie]) {
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
    
    private func updateMovie(with movie: Movie) {
        guard let url = URLHelper.getImageURL(with: movie.posterPath, size: .original) else { return }
        loadingIndicator.startAnimating()
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.movieImage.alpha = 0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            movieImage.sd_setImage(with: url) { [weak self] _, _, _, _ in
                guard let self = self else { return }
                self.loadingIndicator.stopAnimating()
            }
    
            UIView.animate(withDuration: 0.3) {
                self.movieImage.alpha = 1.0
            }
        }
    }
    
    private func applyGradientToImageView() {
        if gradientLayer == nil {
            let newGradientLayer = CAGradientLayer()
            newGradientLayer.colors = [
                UIColor.black.withAlphaComponent(0.6).cgColor,
                UIColor.clear.cgColor,
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(0.6).cgColor
            ]
            newGradientLayer.locations = [0.0, 0.2, 0.8, 1.0]
            newGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            newGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            movieImage.layer.insertSublayer(newGradientLayer, at: 0)
            gradientLayer = newGradientLayer
        }

        gradientLayer?.frame = movieImage.bounds
    }
    
    // MARK: - OBJC FUNCTIONS
    @objc private func didTapOnMovieImage() {
        guard let viewModel = viewModel else { return }
        guard let currentMovie = viewModel.currentMovie else { return }
        viewModel.didTapMovie?(currentMovie)
    }
}
