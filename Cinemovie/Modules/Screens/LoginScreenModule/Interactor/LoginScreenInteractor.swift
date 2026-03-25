//
//  LoginScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

import UIKit

protocol LoginScreenInteractorProtocol: AnyObject {
    // MARK: - LOGIN
    func loginAsGuest()
    func loginWithTMDB()
    
    // MARK: - AUTHENTICATION
    func exchangeRequestTokenForSession(_ token: String)
    func getSessionIDUsingAccessToken(accessToken: String)
}

final class LoginScreenInteractor: LoginScreenInteractorProtocol {
    weak var presenter: LoginScreenPresenterProtocol?
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - LOGIN
    func loginAsGuest() {
        Task {
            do {
                let sessionID = try await networkService.auth.loginAsGuest()
                self.presenter?.didFinishLoging(sessionID: sessionID.guestSessionId)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func loginWithTMDB() {
        Task {
            do {
                let result = try await networkService.auth.createRequestToken()
                self.presenter?.openOAuthURLWithToken(token: result.requestToken)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    // MARK: - AUTHENTICATION
    func exchangeRequestTokenForSession(_ token: String) {
        Task {
            do {
                let sessionID = try await networkService.auth.exchangeRequestToAccessToken(token: token)
                self.presenter?.didLogInWithOAuth(sessionID: sessionID.accessToken)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getSessionIDUsingAccessToken(accessToken: String) {
        Task {
            do {
                let sessionID = try await networkService.auth.getSessionIDUsingAccessToken(token: accessToken)
                self.presenter?.didFinishLoging(sessionID: sessionID.sessionId)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
}
