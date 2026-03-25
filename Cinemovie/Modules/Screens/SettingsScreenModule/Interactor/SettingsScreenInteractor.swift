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
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func showSessionID() {
        print("Yup")
    }
    
    func logout() {
        Task {
            do {
                try await networkService.auth.logout()
            } catch {
                print("Cant log out")
            }
        }
    }
}
