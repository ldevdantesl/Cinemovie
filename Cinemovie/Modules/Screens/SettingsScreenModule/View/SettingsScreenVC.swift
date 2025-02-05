//
//  SettingsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit
import SnapKit

protocol SettingsScreenViewProtocol: AnyObject {
    func didReceiveError(_ errorStr: String)
}

final class SettingsScreenVC: UIViewController {

    var presenter: SettingsScreenPresenterProtocol?
    
    private let logoutButton: UIButton = {
        let button = CMButton(
            text: "Log Out",
            foreColor: CMColor.cmButton,
            textFont: CMFont.buttonFont,
            backColor: CMColor.cmError,
            cornerRadius: 15
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoaded()
        setupUI()
    }
    
    func setupUI() {
        title = "Settings"
        view.backgroundColor = .systemCyan
        view.addSubview(logoutButton)
        
        logoutButton.snp.makeConstraints {
            $0.leading.equalTo(view.snp_leadingMargin)
            $0.trailing.equalTo(view.snp_trailingMargin)
            $0.height.equalTo(50)
            $0.bottom.equalTo(view.snp.bottomMargin).inset(50)
        }
        
        logoutButton.addTarget(self, action: #selector(logoutPressed), for: .touchUpInside)
    }
    
    @objc private func logoutPressed() {
        presenter?.didPressLogoutButton()
    }
}

extension SettingsScreenVC: SettingsScreenViewProtocol {
    func didReceiveError(_ errorStr: String) {
        let alert = UIAlertController(
            title: "Oops...",
            message: errorStr,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}
