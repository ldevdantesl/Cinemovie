//
//  MovieDetailsRateAndShareView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.03.2025.
//

import UIKit
import SnapKit

struct MovieDetailsRateAndShareViewModel: MovieDetailsCellViewModel {
    let identifier: String = "MovieDetailsRateAndShareView"
    
    let didTapShareButton: (() -> Void)?
    let didTapRateButton: (() -> Void)?
}

final class MovieDetailsRateAndShareView: UICollectionViewCell {
    // MARK: - STATIC
    static let identifier = "MovieDetailsRateAndShareView"
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let rateimageSize = 25.0
        static let shareImageSize = 20.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: MovieDetailsRateAndShareViewModel?
    
    // MARK: - VIEW PROPERTIES
    private lazy var rateImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageNames.like.rawValue)
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRate)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var shareImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageNames.share.rawValue)
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapShare)))
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
    public func configure(viewModel: MovieDetailsRateAndShareViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(rateImageView)
        rateImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(Constants.rateimageSize)
        }
        
        addSubview(shareImageView)
        shareImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.height.equalTo(Constants.shareImageSize)
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapShare() {
        viewModel?.didTapShareButton?()
    }
    
    @objc private func didTapRate() {
        viewModel?.didTapRateButton?()
    }
}
