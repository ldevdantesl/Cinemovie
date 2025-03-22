//
//  CMMovieReviewsCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 14.03.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class CMMovieReviewRow: UIView {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let viewCornerRadius: CGFloat = 10
        static let imageCornerRadius: CGFloat = 15
        static let imagePlaceholder: String = "person"
        static let imagePointSize: CGFloat = 15
        static let imageSize: CGFloat = 30
    }

    // MARK: - PADDINGS
    fileprivate enum Paddings {
        static let verticalPadding: CGFloat = 10
        static let horizontalPadding: CGFloat = 10
        static let spacing: CGFloat = 5
    }
    
    private var isRatingViewAdded: Bool = false
    
    // MARK: - PROPERTIES
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = CMColor.cmLabel
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var authorAvatarImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .body, fontName: .avenirDemiBold)
        label.textColor = CMColor.cmLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var reviewContentLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenirDemiBold)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var reviewDateLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenirDemiBold)
        label.textColor = CMColor.cmSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var reviewRatingView: CMStarRatingView = {
        let view = CMStarRatingView()
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
        self.clipsToBounds = true
        self.layer.cornerRadius = Constants.viewCornerRadius
        authorAvatarImageView.layer.cornerRadius = Constants.imageCornerRadius
    }
    
    // MARK: - Public func
    public func configureView(review: DomainReview) {
        if let imageURL = URLHelper.getImageURL(with: review.authorDetails.avatarPath, size: .w92) {
            loadingIndicator.startAnimating()
            authorAvatarImageView.sd_setImage(with: imageURL) { [weak self] _, _, _, _ in
                guard let self = self else { return }
                self.loadingIndicator.stopAnimating()
            }
        } else {
            loadingIndicator.stopAnimating()
            authorAvatarImageView.contentMode = .center
            authorAvatarImageView.backgroundColor = CMColor.cmBorder
            authorAvatarImageView.tintColor = CMColor.cmLabel
            authorAvatarImageView.preferredSymbolConfiguration = .init(pointSize: Constants.imagePointSize, weight: .bold)
            authorAvatarImageView.image = UIImage(systemName: Constants.imagePlaceholder)
        }
        
        authorNameLabel.text = review.author
        reviewDateLabel.text = CMDateFormatter.formatToNormalDateUsingISO8601(dateString: review.createdAt)
        
        if let attributedText = CMTextFormatter.setHTMLText(review.content) {
            let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
            let textColor = CMColor.cmLabel
            mutableAttributedText.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: mutableAttributedText.length))
            reviewContentLabel.attributedText = mutableAttributedText
        } else {
            reviewContentLabel.text = review.content
        }
        
        if let rating = review.authorDetails.rating {
            reviewRatingView.configure(rating: rating)
            reviewContentLabel.snp.remakeConstraints {
                $0.top.equalTo(reviewRatingView.snp.bottom).offset(Paddings.verticalPadding)
                $0.leading.equalToSuperview().offset(Paddings.horizontalPadding)
                $0.trailing.equalToSuperview().offset(-Paddings.horizontalPadding)
                $0.bottom.equalToSuperview().offset(-Paddings.verticalPadding)
            }
        }
    }
    
    // MARK: - Private func
    private func setupUI() {
        self.backgroundColor = CMColor.cmSecondaryBackground
        
        authorAvatarImageView.snp.makeConstraints {
            $0.width.height.equalTo(Constants.imageSize)
        }
        
        let hStack = UIStackView(arrangedSubviews: [authorAvatarImageView, authorNameLabel, UIView(), reviewDateLabel])
        hStack.axis = .horizontal
        hStack.spacing = Paddings.horizontalPadding
        hStack.distribution = .fill
        
        addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Paddings.verticalPadding)
            $0.leading.equalToSuperview().offset(Paddings.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-Paddings.verticalPadding)
        }
        
        addSubview(reviewRatingView)
        reviewRatingView.snp.makeConstraints {
            $0.top.equalTo(hStack.snp.bottom).offset(Paddings.spacing)
            $0.leading.equalToSuperview().offset(Paddings.horizontalPadding)
        }
        
        addSubview(reviewContentLabel)
        reviewContentLabel.snp.makeConstraints {
            $0.top.equalTo(hStack.snp.bottom).offset(Paddings.verticalPadding)
            $0.leading.equalToSuperview().offset(Paddings.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-Paddings.horizontalPadding)
            $0.bottom.equalToSuperview().offset(-Paddings.verticalPadding)
        }
    }
}
