//
//  LoginScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

protocol LoginScreenInteractorProtocol: AnyObject {
    func loginAsGuest()
    func loginWithTMDB()
}

final class LoginScreenInteractor: LoginScreenInteractorProtocol {
    weak var presenter: LoginScreenPresenterProtocol?
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func loginAsGuest() {
        authService.loginAsGuest { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.presenter?.didFinishLogingAsGuest()
            case .failure(let error):
                self.presenter?.didFinishLogingAsGuest(withError: error)
            }
        }
    }
    
    func loginWithTMDB() {
        authService.createRequestToken { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let token): self.presenter?.openOAuthURLWithToken(token: token); print("Token: \(token)")
            case .failure(let error): self.presenter?.cantOpenURLForToken(withError: error)
            }
        }
    }
}
