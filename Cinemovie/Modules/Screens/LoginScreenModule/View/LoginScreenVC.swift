//
//  LoginScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

import UIKit
import SnapKit

protocol LoginScreenViewProtocol: AnyObject { }

final class LoginScreenVC: UIViewController {

    var presenter: LoginScreenPresenterProtocol?
    
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
        label.font = CMFont.bodyFont
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subWelcomeText: UILabel = {
        let label = UILabel()
        label.text = "Select your preferred authentication method"
        label.textColor = CMColor.cmSublabel
        label.font = CMFont.bodyFont
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginButton: CMButton = {
        let button = CMButton(
            text: "Login with TMDB",
            foreColor: CMColor.cmButton,
            textFont: CMFont.buttonFont,
            backColor: CMColor.cmPrimary,
            cornerRadius: 10
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let asGuestButton: CMButton = {
        let button = CMButton(
            text: "Continue as Guest",
            foreColor: CMColor.cmButton,
            textFont: CMFont.buttonFont,
            backColor: CMColor.cmAccent,
            cornerRadius: 10
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc private func loginAsGuest() {
        print("Tapped login as a guest")
        presenter?.didPressLoginAsGuest()
    }
    
    private func setupUI() {
        view.backgroundColor = CMColor.cmBackground
        
        asGuestButton.addTarget(self, action: #selector(loginAsGuest), for: .touchUpInside)
        
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
}

extension LoginScreenVC: LoginScreenViewProtocol { }
