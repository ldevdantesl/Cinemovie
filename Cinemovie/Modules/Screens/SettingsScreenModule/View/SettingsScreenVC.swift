//
//  SettingsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol SettingsScreenViewProtocol: AnyObject { }

final class SettingsScreenVC: UIViewController {

    var presenter: SettingsScreenPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemCyan
    }
}

extension SettingsScreenVC: SettingsScreenViewProtocol { }
