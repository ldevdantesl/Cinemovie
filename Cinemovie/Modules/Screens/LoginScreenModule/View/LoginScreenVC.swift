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
    func didReceiveError(error: AuthError)
    func openURL(_ url: URL)
}

final class LoginScreenVC: UIViewController {
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let buttonCornerRadius = 10.0
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
        return label
    }()
    
    private let subWelcomeText: UILabel = {
        let label = UILabel()
        label.text = "Select your preferred authentication method"
        label.textColor = CMColor.cmSublabel
        label.font = CMFont.font(size: .body)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginButton: CMButton = {
        let vm = CMButtonViewModel(
            text: "Login with TMDB", foreColor: CMColor.cmButton,
            font: CMFont.font(size: .body, fontName: .avenirDemiBold),
            backColor: CMColor.cmPrimary, cornerRadius: Constants.buttonCornerRadius,
            didTapAction: presenter?.didPressLoginWithTMDB
        )
        let button = CMButton(viewModel: vm)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var asGuestButton: CMButton = {
        let vm = CMButtonViewModel(
            text: "Continue as Guest", foreColor: CMColor.cmButton,
            font: CMFont.font(size: .body, fontName: .avenirDemiBold),
            backColor: CMColor.cmAccent, cornerRadius: Constants.buttonCornerRadius,
            didTapAction: presenter?.didPressLoginAsGuest
        )
        let button = CMButton(viewModel: vm)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleOAuthCallback),
            name: Notification.Name(ConstantKeys.OAUTH_CALLBACK.rawValue), object: nil
        )
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        view.backgroundColor = CMColor.cmBackground
        
        logoImg.snp.makeConstraints {
            $0.width.height.equalTo(150)
        }
        
        let welcomeStack = UIStackView(arrangedSubviews: [welcomeText, subWelcomeText])
        welcomeStack.axis = .vertical
        welcomeStack.spacing = 5
        welcomeStack.alignment = .center
        welcomeStack.distribution = .fill
        welcomeStack.translatesAutoresizingMaskIntoConstraints = false
        
        let vStack = UIStackView(arrangedSubviews: [logoImg, welcomeStack])
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.alignment = .center
        vStack.distribution = .fill
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        let spacer = UIView()
        
        let vStack2 = UIStackView(arrangedSubviews: [loginButton, asGuestButton])
        vStack2.axis = .vertical
        vStack2.spacing = 10
        vStack2.alignment = .fill
        vStack2.distribution = .fillEqually
        vStack2.translatesAutoresizingMaskIntoConstraints = false
        
        let finalStack = UIStackView(arrangedSubviews: [vStack, spacer, vStack2])
        finalStack.axis = .vertical
        finalStack.alignment = .fill
        finalStack.spacing = 20
        finalStack.distribution = .fill
        finalStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(finalStack)
        
        finalStack.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        vStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        spacer.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(0)
        }
        
        vStack2.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - OBJC FUNCTIONS
    @objc private func handleOAuthCallback(_ notification: Notification) {
        guard let url = notification.object as? URL else { return }
        presenter?.handleOAuthCallback(url: url)
    }
}

extension LoginScreenVC: LoginScreenViewProtocol {    
    func openURL(_ url: URL) {
        AppOpener.openURL(url)
    }
    
    func didReceiveError(error: AuthError) {
        let alert = UIAlertController(
            title: "Oops...",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
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
