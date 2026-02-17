//
//  ReviewItemContentCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 13.04.2025.
//

import UIKit
import SnapKit

final class ReviewItemContentCellViewModel: CellViewModelBaseClass {
    let review: Review
    let onHeightChangeRequest: (() -> Void)?
    fileprivate var isExpanded: Bool = false
    private(set) var cellHeight = ReviewsTabContentCellViewModel.defaultITemHeight
    
    init(review: Review, onHeightChangeRequest: (() -> Void)?) {
        self.review = review
        self.onHeightChangeRequest = onHeightChangeRequest
        super.init(cellIdentifier: "ReviewItemContentCell")
    }
    
    fileprivate func changeCellHeight(to height: CGFloat) {
        self.cellHeight = height
    }
}

final class ReviewItemContentCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let authorImageBorderWidth = 0.5
        static let authorDefaultImage = "person"
        static let authorImageSize = 20.0
        static let authorImageDefaultPointSize = 10.0
        
        static let viewCornerRadius = 15.0
        
        static let spacing = 5.0
        static let hSpacing = 10.0
        static let vSpacing = 10.0
        
        static let expandButtonSystemName = "chevron.down"
        static let collapseButtonSystemName = "chevron.up"
        static let expandButtonSize = 30
        
        static let defaultHeight = 120.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: ReviewItemContentCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let reviewAuthorImageView: AsyncImageView = {
        let view = AsyncImageView()
        view.setBorder(width: Constants.authorImageBorderWidth, borderColor: CMColor.cmLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let reviewAuthorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .body, fontName: .avenirDemiBoldItalic)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reviewDateLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .footnote, fontName: .avenirUltraLight)
        label.textColor = CMColor.cmSecondary
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reviewStarRatingView: CMStarRatingView = {
        let view = CMStarRatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let reviewContentLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = CMFont.font(size: .caption, fontName: .avenirRegular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "No Rating Left"
        label.font = CMFont.font(size: .body, fontName: .avenirDemiBold)
        label.textColor = CMColor.cmSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var expandButton: CMCircularButton = {
        let button = CMCircularButton()
        button.isHidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        self.reviewAuthorImageView.makeCircular()
        self.contentView.layer.cornerRadius = Constants.viewCornerRadius
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.layoutIfNeeded()
        }
        let isExpanded = viewModel?.isExpanded ?? false
        let height = contentView.systemLayoutSizeFitting(
            CGSize(width: layoutAttributes.frame.width, height: isExpanded ? UIView.layoutFittingCompressedSize.height : Constants.defaultHeight),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: isExpanded ? .fittingSizeLevel : .required
        ).height
        viewModel?.changeCellHeight(to: height)
        layoutAttributes.frame.size.height = height
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reviewDateLabel.text = nil
        self.reviewContentLabel.text = nil
        self.reviewAuthorImageView.image = nil
        self.reviewAuthorNameLabel.text = nil
        self.expandButton.isHidden = true
        self.reviewStarRatingView.configure(rating: 0)
        self.reviewStarRatingView.isHidden = false
        self.noRatingLabel.isHidden = true
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: ReviewItemContentCellViewModel) {
        // MARK: - SETTING
        self.viewModel = viewModel
        self.reviewAuthorNameLabel.text = viewModel.review.authorDetails.username
        self.reviewDateLabel.text = CMDateFormatter.formatToNormalDateUsingISO8601(dateString: viewModel.review.createdAt)
        self.reviewContentLabel.text = viewModel.review.content
        if let rating = viewModel.review.authorDetails.rating, rating != 0 {
            self.reviewStarRatingView.configure(rating: rating)
        } else {
            self.noRatingLabel.isHidden = false
            self.reviewStarRatingView.isHidden = true
        }
        
        // MARK: - EXPAND BUTTON
        DispatchQueue.main.async {
            let lineCount = self.reviewContentLabel.calculateLineCount(using: self.reviewContentLabel.font)
            let needsExpansion = lineCount > 2
            self.expandButton.isHidden = !needsExpansion
            
            if needsExpansion {
                let expandVM = CMCircularButtonViewModel(
                    systemName: Constants.expandButtonSystemName,
                    backColor: .cmSecondary,
                    foreColor: .cmAccent,
                    didTapAction: self.didTapAction
                )
                self.expandButton.configure(viewModel: expandVM)
            }
        }
        
        // MARK: - IMAGE SETTING
        let imagePath = viewModel.review.authorDetails.avatarPath
        reviewAuthorImageView.setAsyncImage(
            path: imagePath, size: .w342,
            notFoundImageSystemName: Constants.authorDefaultImage,
            notFoundPointSize: Constants.authorImageDefaultPointSize
        )
        self.layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.backgroundColor = CMColor.cmSecondaryBackground
        
        contentView.addSubview(reviewAuthorImageView)
        reviewAuthorImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.vSpacing)
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
            $0.size.equalTo(Constants.authorImageSize)
        }
        
        contentView.addSubview(reviewAuthorNameLabel)
        reviewAuthorNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.vSpacing)
            $0.leading.equalTo(reviewAuthorImageView.snp.trailing).offset(Constants.spacing)
            $0.trailing.equalToSuperview().inset(Constants.hSpacing)
            $0.bottom.equalTo(reviewAuthorImageView.snp.bottom)
        }
        
        contentView.addSubview(reviewStarRatingView)
        reviewStarRatingView.snp.makeConstraints {
            $0.top.equalTo(reviewAuthorImageView.snp.bottom).offset(Constants.spacing)
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
        }
        
        contentView.addSubview(noRatingLabel)
        noRatingLabel.snp.makeConstraints {
            $0.top.equalTo(reviewAuthorImageView.snp.bottom).offset(Constants.spacing)
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
        }
        
        contentView.addSubview(reviewDateLabel)
        reviewDateLabel.snp.makeConstraints {
            $0.top.equalTo(reviewStarRatingView.snp.top)
            $0.leading.equalTo(reviewStarRatingView.snp.trailing)
            $0.trailing.equalToSuperview().inset(Constants.hSpacing)
        }
        
        contentView.addSubview(reviewContentLabel)
        reviewContentLabel.snp.makeConstraints {
            $0.top.equalTo(reviewStarRatingView.snp.bottom).offset(Constants.spacing)
            $0.leading.equalToSuperview().inset(Constants.hSpacing)
            $0.trailing.equalToSuperview().inset(Constants.hSpacing)
            $0.bottom.equalToSuperview().inset(Constants.vSpacing).priority(.required)
        }
        
        contentView.addSubview(expandButton)
        expandButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(Constants.vSpacing)
            $0.trailing.equalToSuperview().inset(Constants.hSpacing)
            $0.size.equalTo(Constants.expandButtonSize)
        }
    }
    
    private func didTapAction() {
        guard let viewModel = viewModel else { return }
        viewModel.isExpanded.toggle()
        self.invalidateIntrinsicContentSize()
        let vm = CMCircularButtonViewModel(
            systemName: viewModel.isExpanded ? Constants.collapseButtonSystemName : Constants.expandButtonSystemName,
            backColor: .cmSecondary, foreColor: .cmAccent, didTapAction: didTapAction
        )
        expandButton.configure(viewModel: vm)
        viewModel.onHeightChangeRequest?()
    }
}
