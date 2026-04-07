//
//  RatePopUpView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.04.2026.
//

import UIKit
import SnapKit

struct RatePopUpViewModel: PopUPViewModel {
    let posterPath: String?
    let existingRating: Double?
    var didRate: ((Double) -> Void)?
    var onClose: (() -> Void)?
    
    init(posterPath: String?, existingRating: Double?, didRate: ((Double) -> Void)? = nil, onClose: (() -> Void)? = nil) {
        self.posterPath = posterPath
        self.existingRating = existingRating
        self.onClose = onClose
        self.didRate = didRate
    }
}

final class RatePopUpView: PopUPView {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let posterHeight = UIConstants.screenHeight * 0.3
        static let posterWidth = posterHeight * (2/3)
        static let posterCornerRadius = 10.0
        static let posterBorderWidth = 0.5
        static let starSize = 36.0
        static let starSpacing = 12.0
        static let buttonHeight = 48.0
        static let buttonCornerRadius = 14.0
        static let spacing = 16.0
        static let vSpacing = 20.0
    }

    // MARK: - PROPERTIES
    private let viewModel: RatePopUpViewModel
    private var selectedRating: Int = 0
    private var starButtons: [UIButton] = []
    
    // MARK: - VIEW PROPERTIES
    private lazy var posterImageView: AsyncImageView = {
        let image = AsyncImageView()
        image.setCornerRadius(Constants.posterCornerRadius)
        image.setBorder(width: Constants.posterBorderWidth, borderColor: CMColor.cmLabel)
        image.setAsyncImage(path: viewModel.posterPath, size: .original)
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Rate this"
        label.font = CMFont.font(size: .subtitle, fontName: .avenirDemiBold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var starsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.starSpacing
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenirRegular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - LIFECYCLE
    init(viewModel: RatePopUpViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
        setupUI()
        configureExistingRating()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        setupStars()
        
        addSubview(posterImageView)
        posterImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-Constants.vSpacing)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Constants.posterHeight)
            $0.width.equalTo(Constants.posterWidth)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(Constants.vSpacing)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(starsStackView)
        starsStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacing)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints {
            $0.top.equalTo(starsStackView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview().offset(-Constants.vSpacing)
        }
    }
    
    private func setupStars() {
        for i in 1...5 {
            let button = UIButton(type: .system)
            button.tag = i
            button.tintColor = .systemYellow
            
            let config = UIImage.SymbolConfiguration(pointSize: Constants.starSize, weight: .medium)
            button.setImage(UIImage(systemName: "star", withConfiguration: config), for: .normal)
            button.addTarget(self, action: #selector(didTapStar), for: .touchUpInside)
            
            button.snp.makeConstraints {
                $0.size.equalTo(Constants.starSize + 8)
            }
            
            starButtons.append(button)
            starsStackView.addArrangedSubview(button)
        }
    }
    
    private func configureExistingRating() {
        guard let existingRating = viewModel.existingRating, existingRating > 0 else {
            ratingLabel.text = "Tap a star to rate"
            return
        }
        let starCount = Int(existingRating / 2.0)
        selectedRating = starCount
        updateStars()
    }
    
    private func updateStars() {
        let config = UIImage.SymbolConfiguration(pointSize: Constants.starSize, weight: .medium)
        
        for (index, button) in starButtons.enumerated() {
            let isFilled = index < selectedRating
            let imageName = isFilled ? "star.fill" : "star"
            button.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
            
            UIView.animate(withDuration: 0.15, delay: Double(index) * 0.03, options: .curveEaseOut) {
                button.transform = isFilled ? CGAffineTransform(scaleX: 1.15, y: 1.15) : .identity
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    button.transform = .identity
                }
            }
        }
        
        let tmdbRating = Double(selectedRating) * 2.0
        ratingLabel.text = "\(selectedRating)/5 (\(String(format: "%.1f", tmdbRating))/10)"
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapStar(_ sender: UIButton) {
        selectedRating = sender.tag
        sender.animateTap { [weak self] in
            guard let self else { return }
            self.updateStars()
            let tmdbRating = Double(self.selectedRating) * 2.0
            self.viewModel.didRate?(tmdbRating)
        }
    }
}
