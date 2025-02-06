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
    
    private let movieImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let infoButton: CMCircularButton = {
        let button = CMCircularButton(
            systemName: "info",
            backColor: CMColor.cmSecondaryBackground,
            foreColor: CMColor.cmLabel
        )
        return button
    }()
    
    private let seeButton: CMButton = {
        let button = CMButton(
            text: "Watch",
            foreColor: CMColor.cmLabel,
            textFont: CMFont.subtitleFont,
            backColor: CMColor.cmAccent,
            cornerRadius: 15
        )
        return button
    }()
    
    private let saveButton: CMCircularButton = {
        let button = CMCircularButton(
            systemName: "bookmark",
            backColor: CMColor.cmSecondaryBackground,
            foreColor: CMColor.cmLabel
        )
        return button
    }()
    
    private let ratingView = CMStarRatingView(rating: 0) // 🔧 Keep ratingView persistent

    init(movie: QueryMovie?) {
        super.init(frame: .zero)
        setupUI()
        setupGradient()
        updateMovie(movie) // Now safe to update movie
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        
        let maskPath = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: 8, height: 8)
        )
    
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    // MARK: - PUBLIC FUNCTION
    func updateMovie(_ movie: QueryMovie?) {
        guard let movie = movie else { return }

        // ✅ Update Image Without Creating a New One
        if let url = ImagePathURLHelper.getImageURL(with: movie.posterPath, size: .w1280) {
            activityIndicatorImage.startAnimating()
            movieImage.sd_setImage(with: url) { [weak self] _, _, _, _ in
                self?.activityIndicatorImage.stopAnimating()
                self?.activityIndicatorImage.removeFromSuperview()
            }
        }

        // ✅ Update Rating Instead of Recreating
        ratingView.rating = movie.voteAverage ?? 0
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        addSubview(activityIndicatorImage)
        activityIndicatorImage.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        addSubview(movieImage)
        movieImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let hstack = UIStackView(arrangedSubviews: [infoButton, seeButton, saveButton])
        hstack.axis = .horizontal
        hstack.spacing = 10
        hstack.alignment = .center
        
        addSubview(hstack)
        hstack.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        infoButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }

        saveButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
        
        seeButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        seeButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        seeButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        // ✅ Keep Rating View Persistent Instead of Recreating It
        addSubview(ratingView)
        ratingView.snp.makeConstraints {
            $0.bottom.equalTo(hstack.snp.top).offset(-10)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.black.cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 0.15, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        layer.insertSublayer(gradientLayer, above: movieImage.layer)
    }
}
