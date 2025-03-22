//
//  CMMovieBelongsToCollectionView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 13.03.2025.
//

import UIKit
import SnapKit

final class CMMovieBelongsToCollectionView: UIView {
    // MARK: - Constants
    fileprivate enum Paddings {
        static let spacing: CGFloat = 10
        static let vStackSpacing: CGFloat = 1
    }
    
    fileprivate enum Constants {
        static let vStackHeight: CGFloat = 60
        static let collectionImageViewWidth = UIConstants.screenWidth * 0.1
    }
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = CMColor.cmLabel
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var collectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CMFont.font(size: .body, fontName: .avenirDemiBold)
        label.textColor = CMColor.cmLabel
        return label
    }()
    
    private let collectionSubtitle: UILabel = {
        let label = UILabel()
        label.text = "Collection"
        label.font = CMFont.font(size: .caption, fontName: .avenirDemiBold)
        label.textColor = CMColor.cmSecondary
        return label
    }()
    
    private lazy var collectionImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.layer.cornerRadius = 5
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    public func configure(belongsToCollection: BelongsToCollection) {
        collectionLabel.text = belongsToCollection.name ?? "Uknown"
        if let image = belongsToCollection.posterPath, let imageUrl = URLHelper.getImageURL(with: image, size: .w780) {
            loadingIndicator.startAnimating()
            collectionImageView.sd_setImage(with: imageUrl) { [weak self] _, _, _, _ in
                guard let self = self else { return }
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.removeFromSuperview()
                self.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Private methods
    private func setupUI() {
        let vStack = UIStackView(arrangedSubviews: [collectionLabel, collectionSubtitle])
        vStack.axis = .vertical
        vStack.spacing = Paddings.vStackSpacing
        vStack.alignment = .leading
        
        let hStack = UIStackView(arrangedSubviews: [vStack, UIView(), collectionImageView])
        hStack.axis = .horizontal
        hStack.spacing = Paddings.spacing
        hStack.alignment = .center
        hStack.distribution = .equalSpacing
        
        collectionImageView.snp.makeConstraints {
            $0.width.equalTo(Constants.collectionImageViewWidth)
            $0.height.equalTo(Constants.vStackHeight)
        }
        
        self.addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Paddings.spacing)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(Constants.vStackHeight)
        }
    }
}
