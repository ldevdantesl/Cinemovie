//
//  CMMovieCastListCellCollectionViewCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.02.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class CMMovieCastListCell: UICollectionViewCell {
    static let identifier = "CMMovieCastListCell"
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = CMColor.cmAccent.cgColor
        imageView.layer.borderWidth = 1
        imageView.image = UIImage(
            systemName: "person",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 2, weight: .bold)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC METHOD
    public func configure(item: Cast) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let imageURL = URLHelper.getImageURL(with: item.profilePath, size: .original){
                self.loadingIndicator.startAnimating()
                avatarImageView.sd_setImage(with: imageURL) { [weak self] _, _, _, _ in
                    guard let self = self else { return }
                    self.loadingIndicator.stopAnimating()
                    self.avatarImageView.setNeedsLayout()
                    self.avatarImageView.layoutIfNeeded()
                }
            }
            self.nameLabel.text = item.name
        }
    }
    
    // MARK: - PRIVATE METHOD
    private func setupUI() {
        avatarImageView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(80)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageView.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}
