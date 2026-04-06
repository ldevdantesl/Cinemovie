//
//  SettingsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit
import SafariServices

protocol SettingsScreenRouterProtocol {
    func navigateBackToLogin()
    func presentSelectionModal(pickerType: SettingsSelectionPickerViewModel.PickerType)
    func openAccount(userName: String?)
    func openPrivacyPolicy()
    func openTerms()
}

final class SettingsScreenRouter: SettingsScreenRouterProtocol {
    
    // MARK: - VIPER
    weak var viewController: SettingsScreenVC?
    
    // MARK: - INJECTED
    private weak var sessionDelegate: SessionDelegate?
    private let networkService: NetworkServiceProtocol
    private let userService: UserServiceProtocol
    
    // MARK: - LIFECYCLE
    init(sessionDelegate: SessionDelegate?, diContainer: DIContainer) {
        self.sessionDelegate = sessionDelegate
        self.networkService = diContainer.networkService
        self.userService = diContainer.userService
    }
    
    // MARK: - PUBLIC FUNC
    func navigateBackToLogin() {
        sessionDelegate?.didRequestLogOut()
    }
    
    func presentSelectionModal(pickerType: SettingsSelectionPickerViewModel.PickerType) {
        let viewModel = SettingsSelectionPickerViewModel(pickerType: pickerType, networkService: networkService, userService: userService)
        let vc = SettingsSelectionPickerModalVC(viewModel: viewModel)
        vc.modalPresentationStyle = .pageSheet
        vc.onDismiss = { [weak self] in self?.viewController?.reapplySnapshot() }
    
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        self.viewController?.present(vc, animated: true)
    }
    
    func openAccount(userName: String?) {
        guard let userName,
                let url = URL(string: "\(CONSTANTS.baseUniversalURLString)/u/\(userName)") else { return }
        AppOpener.openURL(url)
    }
    
    func openTerms() {
        guard let url = URL(string: AppInfo.termsURLString), let vc = viewController else { return }
        let safari = SFSafariViewController(url: url)
        vc.present(safari, animated: true)
    }
    
    func openPrivacyPolicy() {
        guard let url = URL(string: AppInfo.privacyPolicyURLString), let vc = viewController else { return }
        let safari = SFSafariViewController(url: url)
        vc.present(safari, animated: true)
    }
}
