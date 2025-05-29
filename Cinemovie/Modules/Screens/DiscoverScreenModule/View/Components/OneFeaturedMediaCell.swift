//
//  OneFeaturedMediaCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.05.2025.
//

import UIKit
import SnapKit

final class OneFeaturedMediaCellViewModel: CellViewModelBaseClass {
    let media: Media
    let didTapAction: ((Media) -> Void)?
    
    init(media: Media, didTapAction: ((Media) -> Void)?) {
        self.media = media
        self.didTapAction = didTapAction
        super.init(cellIdentifier: "OneFeaturedMediaCell")
    }
}

final class OneFeaturedMediaCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let notFoundImageSystemName = "questionmark"
        static let notFoundImagePointSize = 20.0
        static let bottomCornerRadius = 10.0
        static let hSpacing = 10.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: OneFeaturedMediaCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let imageView: AsyncImageView = {
        let view = AsyncImageView()
        view.setCornerRadiusForBottomOnly(Constants.bottomCornerRadius)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let shadowLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor.cmBackground.cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return layer
    }()
    
    private let mediaNameLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .title, fontName: .avenirBold)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private let mediaExtrasLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .body, fontName: .avenirDemiBoldItalic)
        label.textColor = CMColor.cmSublabel
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let height = self.imageView.bounds.height
            let width = self.imageView.bounds.width
            self.shadowLayer.frame = CGRect(
                x: 0, y: height * 0.7,
                width: width, height: height * 0.3
            )
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.reset()
        self.viewModel = nil
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: OneFeaturedMediaCellViewModel) {
        self.viewModel = viewModel
        self.imageView.setAsyncImage(
            path: viewModel.media.posterPath, size: .original,
            notFoundImageSystemName: Constants.notFoundImageSystemName,
            notFoundPointSize: Constants.notFoundImagePointSize
        )
        self.imageView.setAction(target: self, action: #selector(didTapFeaturedMedia))
        self.mediaNameLabel.text = viewModel.media.title
        if let movie = viewModel.media as? Movie {
            self.mediaExtrasLabel.text = "\(CMDateFormatter.formatToYearOnly(dateString: movie.releaseDate)) • \(GenreHelper.shared.getMovieGenreNamesFromIDs(Array(movie.genreIDS.prefix(2))).joined(separator: ", "))"
        } else if let series = viewModel.media as? TVSeries {
            self.mediaExtrasLabel.text = "\(CMDateFormatter.formatToYearOnly(dateString: series.firstAirDate)) • \(GenreHelper.shared.getMovieGenreNamesFromIDs(Array(series.genreIDS.prefix(2))).joined(separator: ", "))"
        }
        self.layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        imageView.layer.addSublayer(shadowLayer)
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.imageView.addSubview(mediaExtrasLabel)
        mediaExtrasLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-Constants.hSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
        }
        
        self.imageView.addSubview(mediaNameLabel)
        mediaNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(mediaExtrasLabel.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapFeaturedMedia() {
        guard let viewModel = viewModel else { return }
        viewModel.didTapAction?(viewModel.media)
    }
}
