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
    let season: TVSeason
    let didTapSeason: ((TVSeason) -> Void)?
    
    init(season: TVSeason, didTapSeason: ((TVSeason) -> Void)?) {
        self.season = season
        self.didTapSeason = didTapSeason
        super.init(cellIdentifier: "SeasonItemContentCell")
    }
}

final class SeasonItemContentCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let loadingIndicatorSize = 10.0
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
    private let posterImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.setCornerRadius(Constants.imageCornerRadius)
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
    
    private lazy var tapContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSeason)))
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
        self.contentView.layer.cornerRadius = Constants.selfCornerRadius
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
        
        let imagePath = viewModel.season.posterPath
        posterImageView.setAsyncImage(
            path: imagePath, size: .w342,
            notFoundImageSystemName: Constants.defaultPosterImageName,
            notFoundPointSize: Constants.imagePointSize
        )
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
        
        addSubview(tapContainer)
        tapContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapSeason() {
        guard let viewModel = viewModel else { return }
        viewModel.didTapSeason?(viewModel.season)
    }
}
