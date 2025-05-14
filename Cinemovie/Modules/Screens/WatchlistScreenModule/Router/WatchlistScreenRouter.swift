//
//  WatchlistScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

protocol WatchlistScreenRouterProtocol {
    func navigateToAccountList(listType: AccountListTypes)
    func navigateToUserList(listID: Int)
    func hidePopUp()
    func presentAddNewListPopUp(onAdd: @escaping ((String, String?, Bool) -> Void))
}

final class WatchlistScreenRouter: WatchlistScreenRouterProtocol {
    weak var viewController: WatchlistScreenVC?
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    func navigateToAccountList(listType: AccountListTypes) {
        let vc = AccountListDetailsScreenAssembler.assemble(listType: listType, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToUserList(listID: Int) {
        let vc = AccountListDetailsScreenAssembler.assemble(listID: listID, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentAddNewListPopUp(onAdd: @escaping ((String, String?, Bool) -> Void)) {
        guard let vcView = viewController?.view else { return }
        let vm = AddNewListPopUpViewModel(didTapAdd: onAdd, onClose: self.hidePopUp)
        let view = AddNewListPopUpView(viewModel: vm)
        view.show(in: vcView)
        self.viewController?.popUpView = view
    }
    
    func hidePopUp() {
        DispatchQueue.main.async {
            self.viewController?.popUpView?.removeFromSuperview()
            self.viewController?.popUpView = nil
        }
    }
}
