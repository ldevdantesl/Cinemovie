//
//  LoginScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

import UIKit

protocol LoginScreenRouterProtocol {
    func routeToMainView()
    func openOAuthURLWithToken(token: String)
    func openOAuthURLWithTokenV4(token: String)
}

final class LoginScreenRouter: LoginScreenRouterProtocol {
    weak var viewController: LoginScreenVC?
    private weak var sessionDelegate: SessionDelegate?
    
    init(sessionDelegate: SessionDelegate?) {
        self.sessionDelegate = sessionDelegate
    }
    
    func openOAuthURLWithToken(token: String) {
        let urlString = CONSTANTS.baseUniversalURLString + "/authenticate/\(token)?redirect_to=cinemovie://callback"
        guard let url = URL(string: urlString) else { return }
        AppOpener.openURL(url)
    }
    
    func openOAuthURLWithTokenV4(token: String) {
        let urlString = CONSTANTS.baseUniversalURLString + "/auth/access?request_token=\(token)"
        guard let url = URL(string: urlString) else { return }
        AppOpener.openURL(url)
    }
    
    func routeToMainView() {
        sessionDelegate?.didRequestLogIn()
    }
}
