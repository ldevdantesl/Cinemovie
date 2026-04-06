//
//  SettingsContentCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.04.2026.
//

import UIKit
import SnapKit

final class SettingsContentCellViewModel: CellViewModelBaseClass {
    let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
        super.init(cellIdentifier: SettingsContentCell.identifier)
    }
}

final class SettingsContentCell: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 10.0
        static let vSpacing = 15.0
        static let cornerRadius = 20.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: SettingsContentCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "CONTENT"
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        vStack.clear()
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(withVM vm: SettingsContentCellViewModel) {
        self.viewModel = vm
        [makeMediaTypePicker(vm: vm), makeToggle(vm: vm)].forEach { vStack.addArrangedSubview($0) }
        layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-Constants.spacing)
        }
    }
    
    private func makeMediaTypePicker(vm: SettingsContentCellViewModel) -> UIView {
        let view = UIView()
        view.backgroundColor = CMColor.cmSecondaryBackground

        let iconContainer = UIView()
        iconContainer.backgroundColor = .systemBlue
        iconContainer.layer.cornerRadius = 10
        iconContainer.clipsToBounds = true

        let icon = UIImageView()
        icon.image = UIImage(systemName: "film.stack")
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .white

        let label = UILabel()
        label.text = "Default Media"
        label.font = CMFont.font(size: .body, fontName: .avenirDemiBold)
        label.numberOfLines = 1

        let menuButton = UIButton(type: .system)
        menuButton.setTitle(vm.userService.defaultMediaType.title, for: .normal)
        menuButton.titleLabel?.font = CMFont.font(size: .caption, fontName: .avenirRegular)
        menuButton.setTitleColor(.secondaryLabel, for: .normal)
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.menu = UIMenu(title: "Default Media Type", children: MediaTypes.allCases.map { type in
            UIAction(
                title: type.title,
                image: UIImage(systemName: type == .movie ? "film" : "tv"),
                state: vm.userService.defaultMediaType == type ? .on : .off
            ) { [weak self] _ in
                self?.viewModel?.userService.defaultMediaType = type
                menuButton.setTitle(type.title, for: .normal)
            }
        })

        let arrowImage = UIImageView()
        arrowImage.image = UIImage(systemName: "chevron.up.chevron.down")
        arrowImage.contentMode = .scaleAspectFit
        arrowImage.tintColor = .tertiaryLabel

        view.addSubview(iconContainer)
        view.addSubview(label)
        view.addSubview(menuButton)
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
        }

        arrowImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-Constants.vSpacing)
            $0.size.equalTo(12)
        }

        menuButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(arrowImage.snp.leading).offset(-5)
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
    
    private func makeToggle(vm: SettingsContentCellViewModel) -> UIView {
        let view = UIView()
        view.backgroundColor = CMColor.cmSecondaryBackground
        
        let iconContainer = UIView()
        iconContainer.backgroundColor = .systemOrange
        iconContainer.layer.cornerRadius = 10
        iconContainer.clipsToBounds = true

        let icon = UIImageView()
        icon.image = UIImage(systemName: "star")
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .white
        
        let label = UILabel()
        label.text = "Include Adult Content"
        label.font = CMFont.font(size: .body, fontName: .avenirDemiBold)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        
        let toggle = UISwitch()
        toggle.isOn = vm.userService.adultEnabled
        toggle.addTarget(self, action: #selector(didChangeAdultContent), for: .valueChanged)

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
        
        return view
    }
    
    // MARK: - OBJC FUNC
    @objc private func didChangeAdultContent(_ sender: UISwitch) {
        viewModel?.userService.adultEnabled = sender.isOn
    }
}
