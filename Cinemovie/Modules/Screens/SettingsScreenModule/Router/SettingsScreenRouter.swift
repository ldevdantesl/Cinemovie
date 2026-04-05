//
//  SettingsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

protocol SettingsScreenRouterProtocol {
    func navigateBackToLogin()
    func presentSelectionModal(pickerType: SettingsSelectionPickerViewModel.PickerType)
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
}
