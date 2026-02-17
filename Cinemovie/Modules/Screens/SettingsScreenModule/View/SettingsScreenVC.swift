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

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let buttonCornerRadius = 15.0
    }
    
    // MARK: - VIPER
    var presenter: SettingsScreenPresenterProtocol?
    
    private lazy var logoutButton: UIButton = {
        let vm = CMButtonViewModel(
            text: "Log Out", foreColor: CMColor.cmButton,
            font: CMFont.font(size: .body, fontName: .avenirDemiBold),
            backColor: CMColor.cmError, didTapAction: presenter?.didPressLogoutButton
        )
        let button = CMButton(viewModel: vm)
        button.setCornerRadius(Constants.buttonCornerRadius)
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
