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

final class EpisodeItemPopUpCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let loadingIndicatorSize = 10.0
        
        static let defaultImageName = "questionmark"
        static let defaultImageSize = 10.0
        static let imageWidth = 120.0
        static let imageHeight = imageWidth * (9 / 16.0)
        static let imageCornerRadius = 10.0
        static let imageBorderWidth = 0.3
        
        static let hSpacing = 10.0
        static let spacing = 5.0
        
        static let selfCornerRadius = 15.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: EpisodeItemPopUpCellViewModel?
    
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
        view.contentMode = .scaleAspectFit
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
    
    private let episodeOverviewLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .footnote, fontName: .avenirRegular)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
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
        self.episodeImageView.contentMode = .scaleAspectFit
        self.episodeTitleLabel.text = nil
        self.episodeOverviewLabel.text = nil
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: EpisodeItemPopUpCellViewModel) {
        self.viewModel = viewModel
        self.episodeTitleLabel.text = viewModel.episode.name
        self.episodeOverviewLabel.text = viewModel.episode.overview
        
        guard let imageURL = URLHelper.getImageURL(with: viewModel.episode.stillPath, size: .w500) else {
            episodeImageView.image = UIImage(systemName: Constants.defaultImageName)
            episodeImageView.preferredSymbolConfiguration = .init(pointSize: Constants.defaultImageSize, weight: .bold)
            episodeImageView.contentMode = .center
            return
        }
        
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
        
        addSubview(episodeImageView)
        episodeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.hSpacing)
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
            $0.width.equalTo(Constants.imageWidth)
            $0.height.equalTo(Constants.imageHeight)
        }
        
        addSubview(episodeTitleLabel)
        episodeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.hSpacing)
            $0.leading.equalTo(episodeImageView.snp.trailing).offset(Constants.hSpacing)
            $0.trailing.equalToSuperview().inset(Constants.hSpacing)
        }
        
        addSubview(episodeOverviewLabel)
        episodeOverviewLabel.snp.makeConstraints {
            $0.top.equalTo(episodeTitleLabel.snp.bottom)
            $0.leading.equalTo(episodeImageView.snp.trailing).offset(Constants.hSpacing)
            $0.trailing.equalToSuperview().inset(Constants.hSpacing)
            $0.bottom.equalToSuperview().inset(Constants.hSpacing)
        }
        
        episodeOverviewLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        episodeOverviewLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}
