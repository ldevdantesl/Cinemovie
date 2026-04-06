//
//  SettingsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol SettingsScreenPresenterProtocol: AnyObject {
    // MARK: - START
    func viewDidLoaded()
    func reapplySnapshot()
    
    func didLogOut()
    func didReceiveAccountDetails(_ details: AccountDetails?)
    func didReceiveError(error: Error)
}

final class SettingsScreenPresenter {
    // MARK: - VIPER
    weak var view: SettingsScreenViewProtocol?
    var router: SettingsScreenRouterProtocol
    var interactor: SettingsScreenInteractorProtocol
    
    // MARK: - INJECTED
    private let userService: UserServiceProtocol
    
    // MARK: - PROPERTIES
    private var accountDetails: AccountDetails?

    init(interactor: SettingsScreenInteractorProtocol, router: SettingsScreenRouterProtocol, userService: UserServiceProtocol) {
        self.interactor = interactor
        self.router = router
        self.userService = userService
    }
    
    private func applySnapshot() {
        let accountVM = SettingsAccountCellViewModel(
            accountDetails: accountDetails,
            didTap: { [weak self] in self?.router.openAccount(userName: self?.accountDetails?.username) }
        )
        let logOutVM = SettingsLogOutCellViewModel(didTap: { [weak self] in self?.logOut() })
        let preferencesVM = SettingsPreferencesCellViewModel(
            userService: userService,
            didTapLanguage: { [weak self] in self?.router.presentSelectionModal(pickerType: .language) },
            didTapRegion: { [weak self] in self?.router.presentSelectionModal(pickerType: .region) } 
        )
        let contentVM = SettingsContentCellViewModel(userService: userService)
        let aboutVM = SettingsAboutCellViewModel(
            userService: self.userService,
            didTapRate: nil,
            didTapPrivacy: { [weak self] in self?.router.openPrivacyPolicy() },
            didTapTerms: { [weak self] in self?.router.openTerms() }
        )
        
        view?.applySnapshot(
            sections: [.header, .account, .body, .footer],
            items: [
                .header : [.header],
                .account : [.account(accountVM)],
                .body : [
                    .preferences(preferencesVM),
                    .content(contentVM),
                    .about(aboutVM)
                ],
                .footer : [
                    .logOut(logOutVM),
                    .footer
                ]
            ]
        )
    }
    
    private func logOut() {
        view?.showLoading()
        interactor.logout()
    }
}

extension SettingsScreenPresenter: SettingsScreenPresenterProtocol {
    // MARK: - STARTING
    func viewDidLoaded() {
        view?.showLoading()
        interactor.loadAccount()
    }
    
    func reapplySnapshot() {
        applySnapshot()
    }
    
    func didReceiveAccountDetails(_ details: AccountDetails?) {
        self.accountDetails = details
        applySnapshot()
        view?.hideLoading()
    }
    
    func didLogOut() {
        view?.hideLoading()
        router.navigateBackToLogin()
    }
    
    func didReceiveError(error: any Error) {
        view?.didReceiveError(error.localizedDescription)
    }
}
