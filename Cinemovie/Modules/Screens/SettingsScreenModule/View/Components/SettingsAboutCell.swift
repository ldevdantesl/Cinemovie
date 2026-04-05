//
//  SettingsAboutCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.04.2026.
//

import UIKit
import SnapKit

final class SettingsAboutCellViewModel: CellViewModelBaseClass {
    let userService: UserServiceProtocol
    let didTapRate: (() -> Void)?
    let didTapPrivacy: (() -> Void)?
    let didTapTerms: (() -> Void)?
    
    init(
        userService: UserServiceProtocol,
        didTapRate: (() -> Void)? = nil,
        didTapPrivacy: (() -> Void)? = nil,
        didTapTerms: (() -> Void)? = nil
    ) {
        self.userService = userService
        self.didTapRate = didTapRate
        self.didTapPrivacy = didTapPrivacy
        self.didTapTerms = didTapTerms
        super.init(cellIdentifier: SettingsAboutCell.identifier)
    }
}

final class SettingsAboutCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 10.0
        static let vSpacing = 15.0
        static let cornerRadius = 20.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: SettingsAboutCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "ABOUT"
        label.textColor = CMColor.cmPlaceholderLabel
        label.font = CMFont.font(size: .caption, fontName: .avenirBold)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var rateButton: UIView = {
        let view = makeButton(image: "bolt.heart", imageBackColor: .systemRed, title: "Rate on App Store")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRateButton)))
        return view
    }()
    
    private lazy var privacyButton: UIView = {
        let view = makeButton(image: "doc.text", imageBackColor: .systemGray, title: "Privacy Policy")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPrivacyButton)))
        return view
    }()
    
    private lazy var termsButton: UIView = {
        let view = makeButton(image: "lock.shield", imageBackColor: .systemGray, title: "Terms of Service")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTermsButton)))
        return view
    }()
    
    private lazy var poweredBy: UIView = {
        let view = makeButton(
            image: "bolt", imageBackColor: .systemBrown,
            showsArrow: false, title: "Powered By TMDB",
            subtitle: "This App uses the TMDB API", dividerAfter: false
        )
        return view
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [rateButton, privacyButton, termsButton, poweredBy])
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
    public func configure(withVM vm: SettingsAboutCellViewModel) {
        self.viewModel = vm
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
    
    private func makeButton(
        image: String, imageBackColor: UIColor, showsArrow: Bool = true,
        title: String, subtitle: String? = nil, dividerAfter: Bool = true
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

        let arrowImage = UIImageView()
        arrowImage.image = UIImage(systemName: "chevron.right")
        arrowImage.contentMode = .scaleAspectFit
        arrowImage.tintColor = .tertiaryLabel
        arrowImage.isHidden = !showsArrow
    
        view.addSubview(iconContainer)
        view.addSubview(label)
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
            $0.trailing.lessThanOrEqualTo(arrowImage.snp.leading).offset(-Constants.spacing)
        }

        arrowImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-Constants.vSpacing)
            $0.size.equalTo(12)
        }
        
        if let subtitleText = subtitle {
            let subtitle = UILabel()
            subtitle.text = subtitleText
            subtitle.font = CMFont.font(size: .custom(12), fontName: .avenirRegular)
            subtitle.textColor = .secondaryLabel
            subtitle.numberOfLines = 1
            subtitle.adjustsFontSizeToFitWidth = true
            subtitle.setContentHuggingPriority(.required, for: .horizontal)
            
            view.addSubview(subtitle)
            subtitle.snp.makeConstraints {
                $0.top.equalTo(label.snp.bottom)
                $0.leading.equalTo(label)
                $0.trailing.lessThanOrEqualTo(arrowImage.snp.leading).offset(-Constants.spacing)
            }
            
            label.snp.remakeConstraints {
                $0.top.equalTo(iconContainer)
                $0.leading.equalTo(iconContainer.snp.trailing).offset(Constants.spacing)
                $0.trailing.lessThanOrEqualTo(arrowImage.snp.leading).offset(-Constants.spacing)
            }
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
    
    // MARK: - OBJC FUNC
    @objc private func didTapRateButton(_ gesture: UIGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.animateTap(onCompletion: viewModel?.didTapRate)
    }
    
    @objc private func didTapPrivacyButton(_ gesture: UIGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.animateTap(onCompletion: viewModel?.didTapPrivacy)
    }
    
    @objc private func didTapTermsButton(_ gesture: UIGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.animateTap(onCompletion: viewModel?.didTapTerms)
    }
}

