//
//  SettingsAccountCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.04.2026.
//

import UIKit
import SnapKit
import SDWebImage

final class SettingsAccountCellViewModel: CellViewModelBaseClass {
    let accountDetails: AccountDetails?
    let didTap: (() -> Void)?
    
    init(accountDetails: AccountDetails?, didTap: (() -> Void)? = nil) {
        self.accountDetails = accountDetails
        self.didTap = didTap
        super.init(cellIdentifier: SettingsAccountCell.identifier)
    }
}

final class SettingsAccountCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 10.0
        static let vSpacing = 15.0
        static let cornerRadius = 15.0
        static let arrowSize = 25.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: SettingsAccountCellViewModel?
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - VIEW PROPERTIES
    private lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = CMColor.cmSecondaryBackground
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        return view
    }()
    
    private let avatarImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .subtitle, fontName: .avenirDemiBold)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let arrowImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = .secondaryLabel
        return iv
    }()
    
    private var characterInAvaLabel: UILabel?
    
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
        container.layoutIfNeeded()
        avatarImage.layoutIfNeeded()
        container.layer.cornerRadius = 15
        avatarImage.layer.cornerRadius = avatarImage.bounds.width / 2
        makeGradientLayer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearAvaImage()
        userNameLabel.text = nil
        arrowImage.isHidden = false
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(withVM vm: SettingsAccountCellViewModel) {
        self.viewModel = vm
        setAccountDetails(accountDetails: vm.accountDetails)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(container)
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        container.addSubview(avatarImage)
        avatarImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.vSpacing)
            $0.leading.equalToSuperview().offset(Constants.spacing)
            $0.bottom.equalToSuperview().offset(-Constants.vSpacing)
            $0.width.equalTo(avatarImage.snp.height)
        }
        
        container.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(avatarImage.snp.centerY)
            $0.leading.equalTo(avatarImage.snp.trailing).offset(Constants.spacing)
        }
        
        container.addSubview(arrowImage)
        arrowImage.snp.makeConstraints {
            $0.centerY.equalTo(avatarImage.snp.centerY)
            $0.trailing.equalToSuperview().offset(-Constants.spacing)
            $0.size.equalTo(Constants.arrowSize)
        }
    }
    
    private func setAccountDetails(accountDetails: AccountDetails?) {
        guard let accountDetails else {
            avatarImage.image = UIImage(named: ImageNames.logoTransparent.rawValue)
            userNameLabel.text = "     Guest"
            arrowImage.isHidden = true
            return
        }
        if let avaPath = accountDetails.avatar.tmdb?.avatarPath, let url = URLHelper.getImageURL(with: avaPath, size: .w500) {
            avatarImage.sd_setImage(with: url)
        } else {
            let nameLabel = UILabel()
            nameLabel.font = CMFont.font(size: .subtitle, fontName: .avenirBold)
            nameLabel.text = "\(accountDetails.username.capitalized.first ?? "?")"
            nameLabel.textColor = CMColor.cmAccent
            nameLabel.numberOfLines = 1
            nameLabel.adjustsFontSizeToFitWidth = true
            self.characterInAvaLabel = nameLabel
            avatarImage.addSubview(nameLabel)
            nameLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            avatarImage.layer.borderColor = CMColor.cmAccent.cgColor
            avatarImage.layer.borderWidth = 2
            layoutIfNeeded()
        }
        
        self.userNameLabel.text = accountDetails.username
    }
    
    private func clearAvaImage() {
        characterInAvaLabel?.removeFromSuperview()
        avatarImage.layer.borderColor = .none
        avatarImage.layer.borderWidth = 0
    }
    
    private func makeGradientLayer() {
        gradientLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.colors = [
            CMColor.cmAccent.withAlphaComponent(0).cgColor,
            CMColor.cmAccent.cgColor,
            CMColor.cmAccent.withAlphaComponent(0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = CGRect(x: 0, y: 0, width: container.bounds.width, height: 2)
        
        container.layer.insertSublayer(gradient, at: 0)
        self.gradientLayer = gradient
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTap() {
        container.animateTap { [weak self] in
            self?.viewModel?.didTap?()
        }
    }
}
