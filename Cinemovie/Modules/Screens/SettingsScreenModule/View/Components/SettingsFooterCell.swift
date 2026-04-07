//
//  SettingsFooterCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.04.2026.
//

import UIKit
import SnapKit

final class SettingsFooterCell: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let appLogoName = ImageNames.appIcon.rawValue
        static let imageCornerRadius = 5.0
        static let version = AppInfo.version
        static let build = AppInfo.build
        
        static let spacing = 10.0
        static let vSpacing = 20.0
        static let logoSize = 25.0
    }
    
    // MARK: - VIEW PROPERTIES
    private let appLogoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: Constants.appLogoName)
        image.clipsToBounds = true
        image.layer.cornerRadius = Constants.imageCornerRadius
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Cinemovie"
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "Version \(Constants.version) · Build \(Constants.build)"
        label.font = CMFont.font(size: .caption, fontName: .avenirRegular)
        label.textColor = CMColor.cmPlaceholderLabel
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [appLogoImage, nameLabel])
        stack.axis = .horizontal
        stack.spacing = Constants.spacing
        stack.distribution = .fill
        
        appLogoImage.snp.makeConstraints {
            $0.size.equalTo(Constants.logoSize)
        }
        return stack
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
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.vSpacing)
            $0.centerX.equalToSuperview()
        }
        
        contentView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints {
            $0.top.equalTo(hStack.snp.bottom).offset(Constants.spacing)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-Constants.spacing)
        }
    }
}
