//
//  CMMovieReviewsView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 13.03.2025.
//

import UIKit
import SnapKit

final class CMMovieReviewsView: UIView {
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let padding: CGFloat = 5
        static let biggerPadding: CGFloat = 10
        static let stackSpacing: CGFloat = 10
        static let imageName: String = "hand.thumbsup.fill"
    }
    
    private enum ReviewSection {
        case main
    }
    
    // MARK: - PROPERTIES
    private lazy var reviewsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackSpacing
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var addRatingButton: CMButton = {
        let button = CMButton(
            text: "Rate", foreColor: CMColor.cmDivider,
            textFont: CMFont.font(size: .body, fontName: .avenirBold), image: UIImage(systemName: Constants.imageName),
            backColor: CMColor.cmLabel, cornerRadius: 15
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var reviewsLabel: UILabel = {
        let label = UILabel()
        label.text = "Reviews"
        label.font = CMFont.font(size: .subtitle, fontName: .avenir)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalReviewsLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .subtitle, fontName: .avenir)
        label.numberOfLines = 1
        label.textColor = CMColor.cmSecondary
        return label
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
    
    // MARK: - Public func
    public func configureReviews(with reviews: [DomainReview], reviewCount: Int) {
        reviews.forEach(createReviews)
        self.totalReviewsLabel.text = "\(reviewCount)"
    }
    
    // MARK: - Private func
    private func setupUI() {
        addSubview(reviewsLabel)
        reviewsLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        addSubview(totalReviewsLabel)
        totalReviewsLabel.snp.makeConstraints {
            $0.bottom.equalTo(reviewsLabel.snp.bottom)
            $0.leading.equalTo(reviewsLabel.snp.trailing).offset(Constants.padding)
        }
        
        addSubview(reviewsStackView)
        reviewsStackView.snp.makeConstraints {
            $0.top.equalTo(reviewsLabel.snp.bottom).offset(Constants.biggerPadding)
            $0.leading.trailing.equalToSuperview()
        }
        
        addSubview(addRatingButton)
        addRatingButton.snp.makeConstraints {
            $0.top.equalTo(reviewsStackView.snp.bottom).offset(Constants.biggerPadding)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func createReviews(review: DomainReview) {
        let view = CMMovieReviewRow()
        view.configureView(review: review)
        reviewsStackView.addArrangedSubview(view)
    }
}

