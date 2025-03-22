//
//  CMMovieBackdropImageCVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.03.2025.
//

import UIKit
import SnapKit
import SDWebImage

struct MediaDetailsBackdropImageViewModel: MovieDetailsCellViewModel {
    let identifier = "MediaDetailsBackdropImageView"
    let imageURL: URL?
    
    init(imagePath: String?, size: ImageSizes) {
        self.imageURL = URLHelper.getImageURL(with: imagePath, size: size)
    }
}

final class MediaDetailsBackdropImageView: UICollectionViewCell {
    
    // MARK: - STATIC
    static let identifier = "MediaDetailsBackdropImageView"
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let indicatorSize: CGFloat = 30
        static let imageNotFoundName = "questionmark.circle"
    }
    
    // MARK: - PROPERTIES
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var backdropImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.preferredSymbolConfiguration = .init(pointSize: 40, weight: .bold)
        view.image = UIImage(systemName: Constants.imageNotFoundName)
        view.clipsToBounds = true
        view.backgroundColor = CMColor.cmSecondaryBackground
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
    public func configure(viewModel: MediaDetailsBackdropImageViewModel) {
        self.loadingIndicator.startAnimating()
        guard let url = viewModel.imageURL else { self.loadingIndicator.stopAnimating(); return }
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        backdropImageView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(Constants.indicatorSize)
        }
        
        contentView.addSubview(backdropImageView)
        backdropImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
