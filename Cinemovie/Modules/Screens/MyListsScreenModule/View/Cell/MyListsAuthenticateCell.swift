//
//  MyListsAuthenticateCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.03.2026.
//

import UIKit
import SnapKit

final class MyListsAuthenticateCellViewModel: CellViewModelBaseClass {
    let didTapAuthenticate: (() -> Void)?
    
    init(didTapAuthenticate: (() -> Void)?) {
        self.didTapAuthenticate = didTapAuthenticate
        super.init(cellIdentifier: MyListsAuthenticateCell.identifier)
    }
}

final class MyListsAuthenticateCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 10.0
        static let hSpacing = 20.0
        static let cornerRadius = 15.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: MyListsAuthenticateCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private var appLogoImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: ImageNames.logoTransparent.rawValue)
        return iv
    }()
    
    private var descLabel: UILabel = {
        let label = UILabel()
        label.text = "Log in to use this screen"
        label.font = CMFont.font(size: .subtitle, fontName: .avenirDemiBold)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private var authButton: CMButton = {
        let vm = CMButtonViewModel(
            text: "Log In", foreColor: .white,
            font: CMFont.font(size: .body, fontName: .avenirBold), backColor: .systemBlue.withAlphaComponent(0.4)
        )
        let button = CMButton(viewModel: vm)
        button.setCornerRadius(Constants.cornerRadius)
        return button
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
    public func configure(withVM vm: MyListsAuthenticateCellViewModel) {
        self.viewModel = vm
        authButton.setAction(action: vm.didTapAuthenticate)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(appLogoImage)
        appLogoImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.2)
            $0.width.equalTo(appLogoImage.snp.height)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.top.equalTo(appLogoImage.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
        }
        
        contentView.addSubview(authButton)
        authButton.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
            $0.bottom.lessThanOrEqualToSuperview().offset(-Constants.spacing)
        }
    }
}
