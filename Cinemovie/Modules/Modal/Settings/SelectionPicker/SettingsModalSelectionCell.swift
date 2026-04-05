//
//  SettingsModalSelectionCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.04.2026.
//

import UIKit
import SnapKit

struct SettingsModalSelectionCellViewModel {
    let name: String
    let code: String
    let flag: String
    var isSelected: Bool
}

final class SettingsModalSelectionCell: UITableViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 10.0
        static let hSpacing = 15.0
        static let imageSize = 25.0
    }
    
    // MARK: - PROPERTIES
    private let flagLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .title)
        label.numberOfLines = 1
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .subtitle, fontName: .avenirDemiBold)
        label.textColor = .white
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .body, fontName: .avenirRegular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let checkmarkImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "checkmark")
        image.tintColor = CMColor.cmSuccess
        return image
    }()
    
    // MARK: - LIFECYCLE
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        flagLabel.text = nil
        nameLabel.text = nil
        codeLabel.text = nil
        checkmarkImage.isHidden = true
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(withVM vm: SettingsModalSelectionCellViewModel) {
        flagLabel.text = vm.flag
        nameLabel.text = vm.name
        codeLabel.text = vm.code
        checkmarkImage.isHidden = !vm.isSelected
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(flagLabel)
        flagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.spacing)
            $0.leading.equalToSuperview().offset(Constants.spacing)
            $0.bottom.equalToSuperview().offset(-Constants.spacing)
        }
        
        contentView.addSubview(checkmarkImage)
        checkmarkImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-Constants.spacing)
            $0.size.equalTo(Constants.imageSize)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(flagLabel)
            $0.leading.equalTo(flagLabel.snp.trailing).offset(Constants.hSpacing)
            $0.trailing.lessThanOrEqualTo(checkmarkImage.snp.leading).offset(-Constants.spacing)
        }
        
        contentView.addSubview(codeLabel)
        codeLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.horizontalEdges.equalTo(nameLabel)
            $0.bottom.equalToSuperview().offset(-Constants.hSpacing)
        }
    }
}
