//
//  SeasonsTabItemContentCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 14.04.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class SeasonItemContentCellViewModel: CellViewModelBaseClass {
    let season: Season
    
    init(season: Season) {
        self.season = season
        super.init(cellIdentifier: "SeasonItemContentCell")
    }
}

final class SeasonItemContentCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let imagePointSize = 15.0
        static let defaultPosterImageName = "questionmark"
        static let imageCornerRadius = 5.0
        static let selfCornerRadius = 15.0
        
        static let hSpacing = 10.0
        static let vSpacing = 10.0
        static let spacing = 5.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: SeasonItemContentCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = CMColor.cmSecondary
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let seasonTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let seasonOverviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmSecondary
        label.font = CMFont.font(size: .caption, fontName: .avenirRegular)
        label.numberOfLines = 3
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let episodeCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .caption, fontName: .avenirDemiBold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.spacing
        stack.alignment = .leading
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        self.contentView.layer.cornerRadius = Constants.selfCornerRadius
        self.posterImageView.layer.cornerRadius = Constants.imageCornerRadius
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: SeasonItemContentCellViewModel) {
        self.viewModel = viewModel
        self.seasonTitleLabel.text = viewModel.season.name
        self.seasonOverviewLabel.text = viewModel.season.overview
        self.episodeCountLabel.text = "\(viewModel.season.episodeCount.description) Episodes"
        vStack.addArrangedSubview(seasonTitleLabel)
        if seasonOverviewLabel.text != nil { vStack.addArrangedSubview(seasonOverviewLabel) }
        vStack.addArrangedSubview(episodeCountLabel)
        
        guard let imageURL = URLHelper.getImageURL(with: viewModel.season.posterPath, size: .w342) else {
            posterImageView.contentMode = .center
            posterImageView.preferredSymbolConfiguration = .init(pointSize: Constants.imagePointSize, weight: .bold)
            posterImageView.image = UIImage(systemName: Constants.defaultPosterImageName)
            return
        }
        loadingIndicator.startAnimating()
        posterImageView.sd_setImage(with: imageURL) { [weak self] _, _, _, _ in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.backgroundColor = CMColor.cmSecondaryBackground
        
        addSubview(posterImageView)
        posterImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(Constants.vSpacing)
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
            $0.width.equalTo(posterImageView.snp.height).dividedBy(1.5)
        }
        
        addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.vSpacing)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(Constants.hSpacing)
            $0.trailing.equalToSuperview().inset(Constants.hSpacing)
            $0.bottom.equalToSuperview().inset(Constants.vSpacing)
        }
    }
}
