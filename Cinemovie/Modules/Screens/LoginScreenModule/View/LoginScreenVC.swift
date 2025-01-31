//
//  LoginScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

import UIKit

protocol LoginScreenViewProtocol: AnyObject { }

final class LoginScreenVC: UIViewController {

    var presenter: LoginScreenPresenterProtocol?
    
    private let welcomeText: UILabel = {
        let label = UILabel()
        label.text = "Welcome to the Cinemovie"
        label.textColor = CMColor.cmLabel
        label.font = CMFont.bodyFont
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LoginScreenVC: LoginScreenViewProtocol { }
