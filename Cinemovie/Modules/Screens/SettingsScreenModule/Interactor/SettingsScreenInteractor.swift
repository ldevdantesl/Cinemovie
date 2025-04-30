//
//  SettingsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

protocol SettingsScreenInteractorProtocol: AnyObject {
    func logout()
    func showSessionID()
}

final class SettingsScreenInteractor: SettingsScreenInteractorProtocol {
    weak var presenter: SettingsScreenPresenterProtocol?
    weak var authService: AuthService?
    
    init(authService: AuthService?) {
        self.authService = authService
    }
    
    func showSessionID() {
        authService?.getSessionID()
    }
    
    func logout() {
        authService?.logout()
    }
}
