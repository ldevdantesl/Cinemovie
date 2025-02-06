//
//  CMPopularMoviesPageContentVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import UIKit
import SDWebImage
import SnapKit

final class CMPopularMoviesPageContentVC: UIViewController {

    private let activityIndicatorImage = UIActivityIndicatorView(style: .large)
    
    private let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let movieTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = CMColor.cmButton
        label.font = CMFont.bodyFont
        label.numberOfLines = 1
        return label
    }()
    
    private let movieOverview: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = CMColor.cmSecondary
        label.font = CMFont.captionFont
        label.numberOfLines = 1
        return label
    }()
    
    init(movie: QueryMovie) {
        super.init(nibName: nil, bundle: nil)
        setupUI()
        
        if let url = ImagePathURLHelper.getImageURL(with: movie.backdropPath, size: .original) {
            activityIndicatorImage.startAnimating()
            backgroundImage.sd_setImage(with: url) { [weak self] image, error, _, _ in
                self?.activityIndicatorImage.stopAnimating()
                self?.activityIndicatorImage.removeFromSuperview()
            }
        }
        
        movieTitle.text = movie.title
        movieOverview.text = movie.overview
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        view.backgroundColor = CMColor.cmSecondary
        
        view.addSubview(backgroundImage)
        
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    
        activityIndicatorImage.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorImage.color = .white
        backgroundImage.addSubview(activityIndicatorImage)
        activityIndicatorImage.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        let overlay = UIView()
        overlay.backgroundColor = .black.withAlphaComponent(0.3)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(overlay)
        
        overlay.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let containerView = UIView()
        containerView.backgroundColor = .black.withAlphaComponent(0.2)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let vstack = UIStackView(arrangedSubviews: [movieTitle, movieOverview])
        vstack.axis = .vertical
        vstack.spacing = 5
        vstack.alignment = .leading
        vstack.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(vstack)
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        vstack.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        vstack.isLayoutMarginsRelativeArrangement = true
        
        vstack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - UIVC Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let maskPath = UIBezierPath(
            roundedRect: backgroundImage.bounds,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: 8, height: 8)
        )
    
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        self.view.layer.mask = maskLayer
    }
}
