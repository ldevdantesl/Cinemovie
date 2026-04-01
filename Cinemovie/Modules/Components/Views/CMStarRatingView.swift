//
//  CMStarRatingView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import UIKit
import SnapKit

final class CMStarRatingView: UIView {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let totalStars = 5
        static let starSize = 20.0
        static let spacing = 5.0
    }
    
    // MARK: - PROPERTIES
    private var starImageViews: [UIImageView] = []
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(rating: Double) {
        let normalizedRating = rating / 2.0
        updateStars(for: normalizedRating)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        for _ in 0..<Constants.totalStars {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            starImageViews.append(imageView)
            addSubview(imageView)
        }
        
        starImageViews.forEach { star in
            star.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.size.equalTo(Constants.starSize)
            }
        }
        
        for (index, star) in starImageViews.enumerated() {
            if index == 0 {
                star.snp.makeConstraints {
                    $0.leading.equalToSuperview()
                }
            } else {
                star.snp.makeConstraints {
                    $0.leading.equalTo(starImageViews[index - 1].snp.trailing).offset(Constants.spacing)
                }
            }
        }
    }
    
    private func updateStars(for rating: Double) {
        for (index, imageView) in starImageViews.enumerated() {
            let starValue = Double(index) + 1
            
            if rating >= starValue {
                imageView.image = UIImage(named: ImageNames.star.rawValue)
            } else if rating >= starValue - 0.5 {
                imageView.image = UIImage(named: ImageNames.halfStar.rawValue)
            } else {
                imageView.image = nil
            }
        }
    }
}
