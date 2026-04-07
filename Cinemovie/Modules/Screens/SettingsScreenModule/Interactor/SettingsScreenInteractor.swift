//
//  SettingsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

protocol SettingsScreenInteractorProtocol: AnyObject {
    func logout()
    func loadAccount()
}

final class SettingsScreenInteractor: SettingsScreenInteractorProtocol {
    weak var presenter: SettingsScreenPresenterProtocol?
    private let authService: AuthServiceProtocol
    private let networkService: NetworkServiceProtocol
    private let authContext: AuthContextProtocol
    
    init(authService: AuthServiceProtocol, networkService: NetworkServiceProtocol, authContext: AuthContextProtocol) {
        self.authService = authService
        self.networkService = networkService
        self.authContext = authContext
    }
    
    func loadAccount() {
        Task {
            do {
                guard let accountID = authContext.accountID else {
                    throw APIError.unauthorized
                }
                let details = try await networkService.account.accountDetails(for: accountID)
                await MainActor.run {
                    self.presenter?.didReceiveAccountDetails(details)
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didReceiveAccountDetails(nil)
                }
            }
        }
    }
    
    func logout() {
        Task {
            do {
                try await authService.logout()
                await MainActor.run {
                    self.presenter?.didLogOut()
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didReceiveError(error: error)
                }
            }
        }
    }
}
