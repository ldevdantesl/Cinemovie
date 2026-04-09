//
//  LoginScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

import UIKit
import SnapKit

protocol LoginScreenViewProtocol: AnyObject {
    func didReceiveError(errorString error: String)
}

final class LoginScreenVC: UIViewController {
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let buttonCornerRadius = 10.0
        static let topOffset = UIConstants.screenHeight / 4
        static let logoSize = 150.0
        static let spacing = 5.0
        static let vSpacing = 10.0
        static let hugeSpacing = 20.0
        static let hSpacing = 20.0
    }
    
    // MARK: - VIPER
    var presenter: LoginScreenPresenterProtocol?
    
    // MARK: - VIEW PROPERTIES
    private let logoImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: ImageNames.logoTransparent.rawValue)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let welcomeText: UILabel = {
        let label = UILabel()
        label.text = "Welcome to the Cinemovie"
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .body)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let subWelcomeText: UILabel = {
        let label = UILabel()
        label.text = "Select your preferred authentication method"
        label.textColor = CMColor.cmSublabel
        label.font = CMFont.font(size: .body)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginButton: CMButton = {
        let vm = CMButtonViewModel(
            text: "Login with TMDB", foreColor: CMColor.cmButton,
            font: CMFont.font(size: .body, fontName: .avenirDemiBold),
            backColor: CMColor.cmPrimary,
            didTapAction: presenter?.didPressLoginWithTMDB
        )
        let button = CMButton(viewModel: vm)
        button.setCornerRadius(Constants.buttonCornerRadius)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var asGuestButton: CMButton = {
        let vm = CMButtonViewModel(
            text: "Continue as Guest", foreColor: CMColor.cmButton,
            font: CMFont.font(size: .body, fontName: .avenirDemiBold),
            backColor: CMColor.cmAccent,
            didTapAction: presenter?.didPressLoginAsGuest
        )
        let button = CMButton(viewModel: vm)
        button.setCornerRadius(Constants.buttonCornerRadius)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        view.backgroundColor = CMColor.cmBackground
        
        view.addSubview(logoImg)
        logoImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.topOffset)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Constants.logoSize)
        }
        
        view.addSubview(welcomeText)
        welcomeText.snp.makeConstraints {
            $0.top.equalTo(logoImg.snp.bottom).offset(Constants.hugeSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
        }
        
        view.addSubview(subWelcomeText)
        subWelcomeText.snp.makeConstraints {
            $0.top.equalTo(welcomeText.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.top.equalTo(subWelcomeText.snp.bottom).offset(Constants.hugeSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
            $0.height.equalTo(UIConstants.buttonHeight)
        }
        
        view.addSubview(asGuestButton)
        asGuestButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(Constants.vSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
            $0.height.equalTo(UIConstants.buttonHeight)
            $0.bottom.lessThanOrEqualToSuperview().priority(.high)
        }
    }
}

extension LoginScreenVC: LoginScreenViewProtocol {
    func didReceiveError(errorString error: String) {
        let alert = UIAlertController(
            title: "Oops...",
            message: "Error: \(error)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
