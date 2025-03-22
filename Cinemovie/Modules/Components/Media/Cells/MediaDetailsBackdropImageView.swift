//
//  CMMovieBackdropImageCVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.03.2025.
//

import UIKit
import SnapKit
import SDWebImage

struct MediaDetailsBackdropImageViewModel: MediaDetailsCellViewModel {
    let identifier = "MediaDetailsBackdropImageView"
    let imageURL: URL?
    let didTapBackButtonAction: (() -> Void)?
    let isBackButtonHidden: Bool
    
    init(imagePath: String?, size: ImageSizes, isBackButtonHidden: Bool, didTapBackButtonAction: (() -> Void)? = nil) {
        self.imageURL = URLHelper.getImageURL(with: imagePath, size: size)
        self.didTapBackButtonAction = didTapBackButtonAction
        self.isBackButtonHidden = isBackButtonHidden
    }
}

final class MediaDetailsBackdropImageView: UICollectionViewCell {
    
    // MARK: - STATIC
    static let identifier = "MediaDetailsBackdropImageView"
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let backButtonSize = 35.0
        static let backButtonSpacing = 10.0
        static let backButtonImageName = "chevron.left"
        
        static let indicatorSize: CGFloat = 30
        static let backdropImageSize: CGFloat = 40
        static let imageNotFoundName = "questionmark.circle"
    }
    
    // MARK: - PROPERTIES
    private var viewModel: MediaDetailsBackdropImageViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let backdropImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.preferredSymbolConfiguration = .init(pointSize: Constants.backdropImageSize, weight: .bold)
        view.image = UIImage(systemName: Constants.imageNotFoundName)
        view.clipsToBounds = true
        view.backgroundColor = CMColor.cmSecondaryBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: CMCircularButton = {
        let view = CMCircularButton()
        view.isHidden = true
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
        self.viewModel = viewModel
        
        let vm = CMCircularButtonViewModel(
            systemName: Constants.backButtonImageName, backColor: CMColor.cmSecondaryBackground,
            foreColor: CMColor.cmAccent, didTapAction: viewModel.didTapBackButtonAction
        )
        backButton.configure(viewModel: vm)
        backButton.isHidden = !viewModel.isBackButtonHidden
        
        guard let url = viewModel.imageURL else { return }
        self.loadingIndicator.startAnimating()
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
        
        contentView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(Constants.backButtonSpacing)
            $0.size.equalTo(Constants.backButtonSize)
        }
    }
}
