//
//  CMFeaturedMovie.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 6.02.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class FeaturedMediaCellViewModel: CellViewModelBaseClass {
    let media: [Media]
    let changeInSeconds: TimeInterval
    let didTapMedia: ((Media) -> Void)?
    
    init(media: [Media], changeInSeconds: TimeInterval = 5.0, didTapMedia: ((Media) -> Void)? = nil) {
        self.media = media
        self.changeInSeconds = changeInSeconds
        self.didTapMedia = didTapMedia
        super.init(cellIdentifier: "FeaturedMediaCell")
    }
}

final class FeaturedMediaCell: ReusableCellBaseClass {
    typealias ViewModel = FeaturedMediaCellViewModel
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let selfCornerRadius = 10.0
        static let selfBorderWidth = 0.3
        
        static let buttonCornerRadius = 10.0
        static let buttonSize = 40.0
        
        static let bigSpacing = 10.0
        static let stackHeight = 70.0
        static let selfHeight = UIConstants.screenHeight * 0.55
    }
    
    // MARK: - PROPERTIES
    private var viewModel: FeaturedMediaCellViewModel?
    private var currentMedia: Media?
    private var mediaWorkItem: DispatchWorkItem?
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - VIEW PROPERTIES
    private let loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.color = CMColor.cmLabel
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mediaImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnMediaImage)))
        return image
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
        clipsToBounds = true
        layer.cornerRadius = Constants.selfCornerRadius
        layer.borderColor = CMColor.cmSecondary.cgColor
        layer.borderWidth = Constants.selfBorderWidth
        applyGradientToImageView()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        layoutAttributes.frame.size.height = Constants.selfHeight
        return layoutAttributes
    }
    
    deinit {
        mediaWorkItem?.cancel()
    }
    
    // MARK: - PUBLIC FUNCTION
    public func configure(with viewModel: FeaturedMediaCellViewModel) {
        self.viewModel = viewModel
        guard let first = viewModel.media.randomElement() else { return }
        updateMedia(with: first)
        self.startMediaLoop()
        self.invalidateIntrinsicContentSize()
    }
    
    public func stopTimer() {
        mediaWorkItem?.cancel()
    }
    
    public func startMediaLoop() {
        guard let viewModel = viewModel else { return }
        mediaWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self, let first = viewModel.media.filter({ $0.id != self.currentMedia?.id }).randomElement() else { return }
            updateMedia(with: first)
            self.startMediaLoop()
        }
        mediaWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + viewModel.changeInSeconds, execute: workItem)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        mediaImage.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        contentView.addSubview(mediaImage)
        mediaImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateMedia(with media: Media) {
        guard let url = URLHelper.getImageURL(with: media.posterPath, size: .original) else { return }
        self.currentMedia = media
        loadingIndicator.startAnimating()
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.mediaImage.alpha = 0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            mediaImage.sd_setImage(with: url) { [weak self] _, _, _, _ in
                guard let self = self else { return }
                self.loadingIndicator.stopAnimating()
            }
            UIView.animate(withDuration: 0.3) {[weak self] in
                guard let self = self else { return }
                self.mediaImage.alpha = 1.0
            }
        }
    }
    
    private func applyGradientToImageView() {
        if gradientLayer == nil {
            let newGradientLayer = CAGradientLayer()
            newGradientLayer.colors = [
                UIColor.black.withAlphaComponent(0.6).cgColor,
                UIColor.clear.cgColor,
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(0.6).cgColor
            ]
            newGradientLayer.locations = [0.0, 0.2, 0.8, 1.0]
            newGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            newGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            mediaImage.layer.insertSublayer(newGradientLayer, at: 0)
            gradientLayer = newGradientLayer
        }

        gradientLayer?.frame = contentView.frame
    }
    
    // MARK: - OBJC FUNCTIONS
    @objc private func didTapOnMediaImage() {
        guard let currentMedia = currentMedia else { return }
        viewModel?.didTapMedia?(currentMedia)
    }
}
