//
//  SeasonItemPopUpCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 16.04.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class EpisodeItemPopUpCellViewModel: CellViewModelBaseClass {
    let episode: TVEpisode
    
    init(episode: TVEpisode) {
        self.episode = episode
        super.init(cellIdentifier: "EpisodeItemPopUpCell")
    }
}

final class EpisodeItemPopUpCell: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let loadingIndicatorSize = 10.0
        
        static let defaultImageName = "questionmark"
        static let defaultImageSize = 10.0
        static let imageWidth = 100.0
        static let imageHeight = imageWidth * (9 / 16.0) + 10
        static let imageCornerRadius = 10.0
        static let imageBorderWidth = 0.3
        
        static let hSpacing = 10.0
        static let spacing = 5.0
        
        static let selfCornerRadius = 15.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: EpisodeItemPopUpCellViewModel?
    private var titleLabelLeadingConstraint: Constraint?
    private var overviewTopLabelLeadingConstraint: Constraint?
    
    // MARK: - VIEW PROPERTIES
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var episodeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = CMColor.cmBackground
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let episodeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenirBold)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let episodeOverviewTopLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .footnote, fontName: .avenirRegular)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let episodeOverviewBottomLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .footnote, fontName: .avenirRegular)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var maxTopOverviewHeight: CGFloat {
        Constants.imageHeight - Constants.spacing - CMFont.font(size: .caption, fontName: .avenirBold).lineHeight
    }
    
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
        self.episodeImageView.layer.cornerRadius = Constants.imageCornerRadius
        self.episodeImageView.layer.borderWidth = Constants.imageBorderWidth
        self.episodeImageView.layer.borderColor = CMColor.cmLabel.cgColor
        self.contentView.layer.cornerRadius = Constants.selfCornerRadius
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.episodeImageView.image = nil
        self.episodeImageView.contentMode = .scaleAspectFill
        self.episodeImageView.isHidden = false
        self.episodeTitleLabel.text = nil
        self.episodeOverviewTopLabel.text = nil
        self.episodeOverviewBottomLabel.text = nil
        
        self.titleLabelLeadingConstraint?.deactivate()
        self.titleLabelLeadingConstraint = nil
        
        self.overviewTopLabelLeadingConstraint?.deactivate()
        self.overviewTopLabelLeadingConstraint = nil
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(
            CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel
        )
        layoutAttributes.frame.size = size
        return layoutAttributes
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: EpisodeItemPopUpCellViewModel) {
        self.viewModel = viewModel
        self.episodeTitleLabel.text = viewModel.episode.name
        
        defer {
            let fullText = (viewModel.episode.overview?.isEmpty ?? true) ? "No overview" : viewModel.episode.overview
            episodeOverviewTopLabel.text = fullText
            episodeOverviewTopLabel.layoutIfNeeded()

            let lines = episodeOverviewTopLabel.getRenderedLines()
            let topText = lines.prefix(3).joined(separator: " ")
            let bottomText = lines.dropFirst(3).joined(separator: " ")

            episodeOverviewTopLabel.text = topText
            episodeOverviewBottomLabel.text = bottomText
        }
        
        guard let imageURL = URLHelper.getImageURL(with: viewModel.episode.stillPath, size: .w500) else {
            episodeImageView.isHidden = true
            
            self.titleLabelLeadingConstraint = episodeTitleLabel.snp.prepareConstraints {
                $0.leading.equalToSuperview().offset(Constants.hSpacing)
            }.first
            titleLabelLeadingConstraint?.activate()
            
            self.overviewTopLabelLeadingConstraint = episodeOverviewTopLabel.snp.prepareConstraints {
                $0.leading.equalToSuperview().offset(Constants.hSpacing)
            }.first
            overviewTopLabelLeadingConstraint?.activate()
            
            self.layoutIfNeeded()
            return
        }
        
        self.titleLabelLeadingConstraint = episodeTitleLabel.snp.prepareConstraints {
            $0.leading.equalTo(episodeImageView.snp.trailing).offset(Constants.hSpacing)
        }.first
        titleLabelLeadingConstraint?.activate()
        
        self.overviewTopLabelLeadingConstraint = episodeOverviewTopLabel.snp.prepareConstraints {
            $0.leading.equalTo(episodeImageView.snp.trailing).offset(Constants.hSpacing)
        }.first
        overviewTopLabelLeadingConstraint?.activate()
        self.layoutIfNeeded()
        
        self.loadingIndicator.startAnimating()
        self.episodeImageView.sd_setImage(with: imageURL) { [weak self] _, _, _, _ in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.backgroundColor = CMColor.cmSecondaryBackground
        episodeImageView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(Constants.loadingIndicatorSize)
        }
        
        contentView.addSubview(episodeImageView)
        episodeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.hSpacing)
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
            $0.width.equalTo(Constants.imageWidth)
            $0.height.equalTo(Constants.imageHeight)
        }
        
        contentView.addSubview(episodeTitleLabel)
        episodeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.hSpacing)
            $0.trailing.equalToSuperview().inset(Constants.hSpacing)
        }

        contentView.addSubview(episodeOverviewTopLabel)
        episodeOverviewTopLabel.snp.makeConstraints {
            $0.top.equalTo(episodeTitleLabel.snp.bottom)
            $0.trailing.equalToSuperview().inset(Constants.hSpacing)
        }
        
        contentView.addSubview(episodeOverviewBottomLabel)
        episodeOverviewBottomLabel.snp.makeConstraints {
            $0.top.equalTo(episodeImageView.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
            $0.bottom.lessThanOrEqualToSuperview().inset(Constants.hSpacing)
        }
    }
}
