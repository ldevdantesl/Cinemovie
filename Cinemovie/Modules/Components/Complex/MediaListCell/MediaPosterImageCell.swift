//
//  CMMovieListComponent.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import SnapKit
import UIKit

final class MediaPosterImageCellViewModel: CellViewModelBaseClass {
    let media: Media
    let didTapMedia: ((Media) -> Void)?
    
    init(media: Media, didTapMedia: ((Media) -> Void)? = nil) {
        self.media = media
        self.didTapMedia = didTapMedia
        super.init(cellIdentifier: "MediaPosterImageCell")
    }
}

final class MediaPosterImageCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let cornerRadius = 10.0
        static let borderWidth = 0.2
        static let imageNotFoundName = "questionmark"
        static let imageNotFoundPointSize = 20.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: MediaPosterImageCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var posterImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = CMColor.cmSecondaryBackground
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMedia)))
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
        self.posterImageView.layer.cornerRadius = Constants.cornerRadius
        self.posterImageView.layer.borderColor = CMColor.cmLabel.cgColor
        self.posterImageView.layer.borderWidth = Constants.borderWidth
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImageView.contentMode = .scaleAspectFill
        self.posterImageView.image = nil
    }
    
    // MARK: - PUBLIC FUNCTIONS
    public func configure(with viewModel: MediaPosterImageCellViewModel) {
        self.viewModel = viewModel
        guard let url = URLHelper.getImageURL(with: viewModel.media.posterPath, size: .w1280) else {
            posterImageView.image = UIImage(systemName: Constants.imageNotFoundName)
            posterImageView.preferredSymbolConfiguration = .init(pointSize: Constants.imageNotFoundPointSize, weight: .bold)
            posterImageView.tintColor = CMColor.cmAccent
            posterImageView.contentMode = .center
            return
        }
        self.loadingIndicator.startAnimating()
        self.posterImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        posterImageView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        addSubview(posterImageView)
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapMedia() {
        guard let media = viewModel?.media else { return }
        viewModel?.didTapMedia?(media)
    }
}
