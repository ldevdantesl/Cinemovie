//
//  CMMovieCastListCellCollectionViewCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.02.2025.
//

import UIKit
import SnapKit
import SDWebImage

struct CastListItemCellViewModel: Hashable {
    let cast: Cast?
}

final class CastListItemCell: UICollectionViewCell, ReusableCell {

    // MARK: - CONSTANTS
    fileprivate enum Paddings {
        static let imageViewTopPadding: CGFloat = 10
        static let spacer: CGFloat = 5
    }
    
    fileprivate enum Constants {
        static let loadingIndicatorSize: CGFloat = 20
        
        static let imageViewCornerRadius: CGFloat = 20
        static let imageViewBorderWidth: CGFloat = 1
        static let imageSize: CGFloat = 80
        static let imageViewImageName = "person"
        static let imageViewImagePointSize: CGFloat = 20
        
        static let unknownText: String = "Unknown"
    }
    
    // MARK: - PROPERTIES
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .tiny, fontName: .avenirDemiBold)
        label.textColor = CMColor.cmLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var characterName: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmSecondary
        label.font = CMFont.font(size: .tiny, fontName: .avenirDemiBold)
        label.translatesAutoresizingMaskIntoConstraints = false
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
        avatarImageView.layer.cornerRadius = Constants.imageViewCornerRadius
        avatarImageView.layer.borderColor = CMColor.cmAccent.cgColor
        avatarImageView.layer.borderWidth = Constants.imageViewBorderWidth
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.avatarImageView.image = nil
        self.nameLabel.text = nil
        self.characterName.text = nil
        self.avatarImageView.sd_cancelCurrentImageLoad()
    }
    
    // MARK: - PUBLIC METHOD
    public func configure(viewModel: CastListItemCellViewModel) {
        guard let cast = viewModel.cast else { return }
        
        self.nameLabel.text = cast.name
        self.characterName.text = cast.character ?? cast.job ?? Constants.unknownText
        guard let imageURL = URLHelper.getImageURL(with: cast.profilePath, size: .original) else {
            self.avatarImageView.contentMode = .center
            self.avatarImageView.image = UIImage(
                systemName: Constants.imageViewImageName,
                withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.imageViewImagePointSize, weight: .bold)
            )
            self.avatarImageView.backgroundColor = CMColor.cmSecondaryBackground
            return
        }
        self.loadingIndicator.startAnimating()
        self.avatarImageView.contentMode = .scaleAspectFill
        self.avatarImageView.sd_setImage(with: imageURL) { [weak self] _, _, _, _ in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
            self.avatarImageView.setNeedsLayout()
            self.avatarImageView.layoutIfNeeded()
        }
    }
    
    // MARK: - PRIVATE METHOD
    private func setupUI() {
        avatarImageView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(Constants.loadingIndicatorSize)
        }
        
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(Constants.imageSize)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Constants.imageSize)
        }
        
        contentView.addSubview(characterName)
        characterName.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.lessThanOrEqualTo(Constants.imageSize)
            $0.bottom.equalToSuperview()
        }
    }
}
