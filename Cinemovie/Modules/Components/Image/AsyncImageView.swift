//
//  AsyncImageView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.04.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class AsyncImageView: UIImageView {
    
    // MARK: - PROPERTIES
    private var cornerRadius: CGFloat = 0
    private var borderWidth: CGFloat = 0
    private var borderColor: UIColor?
    
    // MARK: - VIEW PROPERTIES
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init() {
        self.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor?.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    // MARK: - PUBLIC FUNC
    public func setAsyncImage(path: String?, size: TMDBImageSizes, notFoundImageSystemName: String, notFoundPointSize: CGFloat, notFoundTintColor: UIColor = CMColor.cmAccent) {
        guard let url = URLHelper.getImageURL(with: path, size: size) else {
            self.image = UIImage(systemName: notFoundImageSystemName)
            self.preferredSymbolConfiguration = .init(pointSize: notFoundPointSize, weight: .bold)
            self.tintColor = notFoundTintColor
            self.contentMode = .center
            return
        }
        
        self.sd_cancelCurrentImageLoad()
        self.loadingIndicator.startAnimating()
        self.sd_setImage(
            with: url, placeholderImage: nil,
            options: [.scaleDownLargeImages]
        ) { [weak self] image, error, cacheType, url in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
            self.image = image
            self.layoutIfNeeded()
        }
    }
    
    public func setAction(target: Any?, action: Selector) {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
    public func setCornerRadius(_ radius: CGFloat) {
        self.cornerRadius = radius
        self.layoutIfNeeded()
    }
    
    public func setBorder(width: CGFloat?, borderColor: UIColor?) {
        self.borderWidth = width ?? 0
        self.borderColor = borderColor
        self.layoutIfNeeded()
    }
    
    public func makeCircular() {
        self.layoutIfNeeded()
        self.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    public func reset() {
        self.image = nil
        self.tintColor = nil
        self.contentMode = .scaleAspectFill
        self.preferredSymbolConfiguration = nil
        self.sd_cancelCurrentImageLoad()
    }
    
    // MARK: - PRIVATE FUNC
    private func setup() {
        self.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.backgroundColor = CMColor.cmSecondaryBackground
    }
}
