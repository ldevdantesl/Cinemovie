//
//  TVSeriesDetailsSubDetailsView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 23.03.2025.
//

import UIKit
import SnapKit

struct TVSeriesDetailsSubDetailsViewModel: MediaDetailsCellViewModel {
    let identifier: String = "TVSeriesDetailsSubDetailsView"
    
    let firstAirDate: String
    let status: TVSeriesStatus
    let numberOfSeasons: Int
    let numberOfEpisodes: Int
    let nextEpisodeToAir: String?
    let homepage: String?
    let didTapView: ((UIView, String) -> Void)?
    let didTapHomepage: ((String) -> Void)?
    let cellHeight = 25.0
    
    init(
        firstAirDate: String, numberOfSeasons: Int,
        numberOfEpisodes: Int, status: TVSeriesStatus,
        nextEpisodeToAir: String?, didTapView: ((UIView, String) -> Void)? = nil
    ) {
        self.firstAirDate = firstAirDate
        self.status = status
        self.nextEpisodeToAir = nextEpisodeToAir
        self.numberOfSeasons = numberOfSeasons
        self.numberOfEpisodes = numberOfEpisodes
        self.didTapView = didTapView
        self.homepage = nil
        self.didTapHomepage = nil
    }
    
    init(
        firstAirDate: String, numberOfSeasons: Int,
        numberOfEpisodes: Int, homepage: String?,
        status: TVSeriesStatus, nextEpisodeToAir: String?,
        didTapView: ((UIView, String) -> Void)? = nil,
        didTapHomepage: ((String) -> Void)? = nil
    ) {
        self.firstAirDate = firstAirDate
        self.status = status
        self.nextEpisodeToAir = nextEpisodeToAir
        self.numberOfSeasons = numberOfSeasons
        self.numberOfEpisodes = numberOfEpisodes
        self.didTapView = didTapView
        self.homepage = homepage
        self.didTapHomepage = didTapHomepage
    }
}

final class TVSeriesDetailsSubDetailsView: UICollectionViewCell {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let hStackSpacing = 10.0
        static let imageSizes: CGFloat = 20
    }
    
    // MARK: - STATIC
    static let identifier = "TVSeriesDetailsSubDetailsView"
    
    // MARK: - PROPERTIES
    private var viewModel: TVSeriesDetailsSubDetailsViewModel?
    
    // MARK: - VIEW PROPERTIES
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            airDateLabel, statusImageView,
            seriesDurationLabel, hdStatusImageView,
             mediaTypeImageView, UIView(), homepageImageView
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Constants.hStackSpacing
        return stackView
    }()
    
    private lazy var airDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.accessibilityIdentifier = "AirDateLabel"
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTooltip)))
        label.font = CMFont.font(size: .caption, fontName: .avenirDemiBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statusImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTooltip)))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var hdStatusImageView: UIImageView = {
        let image = UIImageView()
        image.accessibilityIdentifier = "HDStatusImage"
        image.image = UIImage(named: ImageNames.HD.rawValue)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTooltip)))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var mediaTypeImageView: UIImageView = {
        let view = UIImageView()
        view.accessibilityIdentifier = "MediaTypeImage"
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: ImageNames.tvSeriesID.rawValue)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTooltip)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var seriesDurationLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "SeriesDurationLabel"
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTooltip)))
        label.font = CMFont.font(size: .caption, fontName: .avenirDemiBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var homepageImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHomepage)))
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
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: TVSeriesDetailsSubDetailsViewModel) {
        self.viewModel = viewModel
        self.airDateLabel.text = CMDateFormatter.formatToYearOnly(dateString: viewModel.firstAirDate)
        self.statusImageView.image = UIImage(named: "TVSeriesStatus_\(viewModel.status.rawValue)")
        self.statusImageView.accessibilityIdentifier = "TVSeriesStatus_\(viewModel.status.rawValue)"
        self.seriesDurationLabel.text = "\(viewModel.numberOfSeasons)S \(viewModel.numberOfEpisodes)E"
        self.mediaTypeImageView.image = UIImage(named: ImageNames.tvSeriesID.rawValue)
        guard let homepage = viewModel.homepage, !homepage.isEmpty else { return }
        self.homepageImageView.image = UIImage(named: ImageNames.homepage.rawValue)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        hdStatusImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.imageSizes)
        }
        
        statusImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.imageSizes)
        }
        
        mediaTypeImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.imageSizes)
        }
        
        homepageImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.imageSizes)
        }
        
        contentView.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapHomepage() {
        guard let homepage = viewModel?.homepage else { return }
        viewModel?.didTapHomepage?(homepage)
    }
    
    @objc private func showTooltip(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        guard let id = view.accessibilityIdentifier else { return }
        viewModel?.didTapView?(view, id)
    }
}
