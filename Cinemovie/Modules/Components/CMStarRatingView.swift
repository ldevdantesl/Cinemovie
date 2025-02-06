//
//  CMStarRatingView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import UIKit

final class CMStarRatingView: UIView {
    private let starCount: Int = 5
    private let filledStarImage = UIImage(systemName: "star.fill")
    private let emptyStarImage = UIImage(systemName: "star")
    private var starImageViews: [UIImageView] = []
    
    private let starStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 5
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()
    
    var rating: CGFloat = 0 {
        didSet {
            updateStars()
        }
    }
    
    init(rating: CGFloat = 0) {
        self.rating = rating
        super.init(frame: .zero)
        setupView()
        updateStars()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(starStackView)
        mainStackView.addArrangedSubview(ratingLabel)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        for _ in 0..<starCount {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .systemYellow
            starStackView.addArrangedSubview(imageView)
            starImageViews.append(imageView)
        }
    }
    
    private func updateStars() {
        let normalizedRating = (rating / 10.0) * CGFloat(starCount)
        
        for (index, imageView) in starImageViews.enumerated() {
            if CGFloat(index) < normalizedRating {
                imageView.image = filledStarImage
            } else {
                imageView.image = emptyStarImage
            }
        }
        
        ratingLabel.text = String(format: "%.1f/10 TMDB", rating)
    }
}
