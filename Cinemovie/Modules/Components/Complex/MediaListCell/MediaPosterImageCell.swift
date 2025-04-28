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
    private lazy var posterImageView: AsyncImageView = {
        let view = AsyncImageView()
        view.setAction(target: self, action: #selector(didTapMedia))
        view.setCornerRadius(Constants.cornerRadius)
        view.setBorder(width: Constants.borderWidth, borderColor: CMColor.cmLabel)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImageView.reset()
    }
    
    // MARK: - PUBLIC FUNCTIONS
    public func configure(with viewModel: MediaPosterImageCellViewModel) {
        self.viewModel = viewModel
        self.posterImageView.setAsyncImage(
            path: viewModel.media.posterPath, size: .w1280,
            notFoundImageSystemName: Constants.imageNotFoundName,
            notFoundPointSize: Constants.imageNotFoundPointSize
        )
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        contentView.addSubview(posterImageView)
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
