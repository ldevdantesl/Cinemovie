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
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func showSessionID() {
        
    }
    
    func logout() {
        Task {
            do {
                try await authService.logout()
            } catch {
                print("Cant log out")
            }
        }
    }
}
