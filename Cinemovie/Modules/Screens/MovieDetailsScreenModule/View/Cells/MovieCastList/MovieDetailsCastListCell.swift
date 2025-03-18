//
//  CMMovieCastListCellCollectionViewCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.02.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class CMMovieDetailsCastListCell: UICollectionViewCell {
    
    // MARK: - STATIC
    static let identifier = Constants.identifier
    
    // MARK: - CONSTANTS
    fileprivate enum Paddings {
        static let imageViewTopPadding: CGFloat = 10
        static let spacer: CGFloat = 5
    }
    
    fileprivate enum Constants {
        static let identifier = "CMMovieDetailsCastListCell"
        
        static let loadingIndicatorSize: CGFloat = 20
        
        static let imageViewCornerRadius: CGFloat = 20
        static let imageViewBorderWidth: CGFloat = 1
        static let imageSize: CGFloat = 80
        static let imageViewImageName = "person"
        static let imageViewImagePointSize: CGFloat = 20
        
        static let labelWidth: CGFloat = 90
        
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
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.imageViewCornerRadius
        imageView.layer.borderColor = CMColor.cmAccent.cgColor
        imageView.layer.borderWidth = Constants.imageViewBorderWidth
        imageView.image = UIImage(
            systemName: Constants.imageViewImageName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.imageViewImagePointSize, weight: .bold)
        )
        imageView.backgroundColor = CMColor.cmSecondaryBackground
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .tiny, fontName: .avenir)
        label.textColor = CMColor.cmLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var characterName: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmSecondary
        label.font = CMFont.font(size: .tiny, fontName: .avenir)
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
    
    // MARK: - PUBLIC METHOD
    public func configure(cast: Cast?) {
        guard let cast = cast else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let imageURL = URLHelper.getImageURL(with: cast.profilePath, size: .original){
                self.loadingIndicator.startAnimating()
                self.avatarImageView.contentMode = .scaleAspectFill
                avatarImageView.sd_setImage(with: imageURL) { [weak self] _, _, _, _ in
                    guard let self = self else { return }
                    self.loadingIndicator.stopAnimating()
                    self.avatarImageView.setNeedsLayout()
                    self.avatarImageView.layoutIfNeeded()
                }
            } else {
                
            }
            self.nameLabel.text = cast.name
            self.characterName.text = cast.character ?? cast.job ?? Constants.unknownText
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
            $0.top.equalTo(avatarImageView.snp.bottom).offset(Paddings.spacer)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Constants.labelWidth)
        }
        
        contentView.addSubview(characterName)
        characterName.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.lessThanOrEqualTo(Constants.labelWidth)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}
