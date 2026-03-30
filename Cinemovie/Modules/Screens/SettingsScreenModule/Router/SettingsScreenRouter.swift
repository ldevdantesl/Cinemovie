//
//  SettingsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

protocol SettingsScreenRouterProtocol {
    func navigateBackToLogin()
}

final class SettingsScreenRouter: SettingsScreenRouterProtocol {
    weak var viewController: SettingsScreenVC?
    private weak var sessionDelegate: SessionDelegate?
    
    init(sessionDelegate: SessionDelegate?) {
        self.sessionDelegate = sessionDelegate
    }
    
    func navigateBackToLogin() {
        sessionDelegate?.didRequestLogOut()
    }
}
