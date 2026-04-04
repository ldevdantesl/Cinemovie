//
//  SettingsPreferencesCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.04.2026.
//

import UIKit
import SnapKit

final class SettingsPreferencesCellViewModel: CellViewModelBaseClass {
    let userService: UserServiceProtocol
    let didTapLanguage: (() -> Void)?
    let didToggleNotifications: ((Bool) -> Void)?
    let didTapRegion: (() -> Void)?
    
    init(
        userService: UserServiceProtocol,
        didTapLanguage: (() -> Void)? = nil,
        didToggleNotifications: ((Bool) -> Void)? = nil,
        didTapRegion: (() -> Void)? = nil
    ) {
        self.userService = userService
        self.didTapLanguage = didTapLanguage
        self.didToggleNotifications = didToggleNotifications
        self.didTapRegion = didTapRegion
        super.init(cellIdentifier: SettingsPreferencesCell.identifier)
    }
}

final class SettingsPreferencesCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 10.0
        static let vSpacing = 15.0
        static let cornerRadius = 20.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: SettingsPreferencesCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "PREFERENCES"
        label.textColor = CMColor.cmPlaceholderLabel
        label.font = CMFont.font(size: .caption, fontName: .avenirBold)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = 0
        stack.clipsToBounds = true
        stack.layer.cornerRadius = Constants.cornerRadius
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
    
    // MARK: - PUBLIC FUNC
    public func configure(withVM vm: SettingsPreferencesCellViewModel) {
        self.viewModel = vm
        
        let languageButton = makeButton(
            image: "globe", imageBackColor: .systemBlue,
            title: "Language",
            value: vm.userService.userLanguage
        )
        let notifications = makeToggle()
        
        let region = makeButton(
            image: "globe.americas",
            imageBackColor: .systemGreen,
            title: "Region", value: "US",
            dividerAfter: false
        )
        
        [languageButton, notifications, region].forEach { vStack.addArrangedSubview($0) }
        
        layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func makeButton(
        image: String, imageBackColor: UIColor,
        title: String, value: String, dividerAfter: Bool = true
    ) -> UIView {
        let view = UIView()
        view.backgroundColor = CMColor.cmSecondaryBackground

        let iconContainer = UIView()
        iconContainer.backgroundColor = imageBackColor
        iconContainer.layer.cornerRadius = 10
        iconContainer.clipsToBounds = true

        let icon = UIImageView()
        icon.image = UIImage(systemName: image)
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .white

        let label = UILabel()
        label.text = title
        label.font = CMFont.font(size: .body, fontName: .avenirDemiBold)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = CMFont.font(size: .caption, fontName: .avenirRegular)
        valueLabel.textColor = .secondaryLabel
        valueLabel.numberOfLines = 1
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.setContentHuggingPriority(.required, for: .horizontal)

        let arrowImage = UIImageView()
        arrowImage.image = UIImage(systemName: "chevron.right")
        arrowImage.contentMode = .scaleAspectFit
        arrowImage.tintColor = .tertiaryLabel
    
        view.addSubview(iconContainer)
        view.addSubview(label)
        view.addSubview(valueLabel)
        view.addSubview(arrowImage)

        iconContainer.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.vSpacing)
            $0.top.equalToSuperview().offset(Constants.vSpacing)
            $0.bottom.equalToSuperview().offset(-Constants.vSpacing)
            $0.size.equalTo(35)
        }
        
        iconContainer.addSubview(icon)
        icon.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(25)
        }

        label.snp.makeConstraints {
            $0.centerY.equalTo(iconContainer)
            $0.leading.equalTo(iconContainer.snp.trailing).offset(Constants.spacing)
            $0.trailing.lessThanOrEqualTo(valueLabel.snp.leading).offset(-Constants.spacing)
        }

        arrowImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-Constants.vSpacing)
            $0.size.equalTo(12)
        }

        valueLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(arrowImage.snp.leading).offset(-5)
        }
        
        guard dividerAfter else {
            return view
        }
        
        let divider = UIView()
        divider.backgroundColor = .systemGray2
        
        view.addSubview(divider)
        divider.snp.makeConstraints {
            $0.leading.equalTo(iconContainer.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        return view
    }
    
    private func makeToggle() -> UIView {
        let view = UIView()
        view.backgroundColor = CMColor.cmSecondaryBackground
        
        let iconContainer = UIView()
        iconContainer.backgroundColor = .systemOrange
        iconContainer.layer.cornerRadius = 10
        iconContainer.clipsToBounds = true

        let icon = UIImageView()
        icon.image = UIImage(systemName: "bell")
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .white
        
        let label = UILabel()
        label.text = "Notifications"
        label.font = CMFont.font(size: .body, fontName: .avenirDemiBold)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.addTarget(self, action: #selector(didChangeNotifications), for: .valueChanged)

        view.addSubview(iconContainer)
        view.addSubview(label)
        view.addSubview(toggle)

        iconContainer.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.vSpacing)
            $0.top.equalToSuperview().offset(Constants.vSpacing)
            $0.bottom.equalToSuperview().offset(-Constants.vSpacing)
            $0.size.equalTo(35)
        }
        
        iconContainer.addSubview(icon)
        icon.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(25)
        }

        label.snp.makeConstraints {
            $0.centerY.equalTo(iconContainer)
            $0.leading.equalTo(iconContainer.snp.trailing).offset(Constants.spacing)
        }

        toggle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-Constants.spacing)
        }
        
        let divider = UIView()
        divider.backgroundColor = .systemGray2
        
        view.addSubview(divider)
        divider.snp.makeConstraints {
            $0.leading.equalTo(iconContainer.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        return view
    }
    
    // MARK: - OBJC FUNC
    @objc private func didChangeNotifications(_ sender: UISwitch) {
        viewModel?.didToggleNotifications?(sender.isOn)
    }
}
