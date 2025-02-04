//
//  LoginScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

protocol LoginScreenInteractorProtocol: AnyObject {
    func loginAsGuest()
}

final class LoginScreenInteractor: LoginScreenInteractorProtocol {
    weak var presenter: LoginScreenPresenterProtocol?
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func loginAsGuest() {
        authService.loginAsGuest()
    }
}
