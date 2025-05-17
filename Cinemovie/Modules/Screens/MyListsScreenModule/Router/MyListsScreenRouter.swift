//
//  WatchlistScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

protocol MyListsScreenRouterProtocol {
    func navigateToAccountList(listType: AccountListTypes)
    func navigateToUserList(userList: UserList)
    func showLoadingBox()
    
    func hideLoadingBox(success: Bool, message: String)
    func hidePopUp()
    func presentAddNewListPopUp(onAdd: @escaping ((String, String?, Bool) -> Void))
}

final class MyListsScreenRouter: MyListsScreenRouterProtocol {
    weak var viewController: MyListsScreenVC?
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    func navigateToAccountList(listType: AccountListTypes) {
        let vc = AccountListDetailsScreenAssembler.assemble(listType: listType, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToUserList(userList: UserList) {
        let vc = UserListDetailsScreenAssembler.assemble(userList: userList, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentAddNewListPopUp(onAdd: @escaping ((String, String?, Bool) -> Void)) {
        guard let vcView = viewController?.view else { return }
        let vm = AddNewListPopUpViewModel(didTapAdd: onAdd) { [weak self] in
            guard let self = self else { return }
            self.hidePopUp()
        }
        let view = AddNewListPopUpView(viewModel: vm)
        view.show(in: vcView)
        self.viewController?.popUpView = view
    }
    
    func hidePopUp() {
        DispatchQueue.main.async {
            self.viewController?.popUpView?.dismiss()
            self.viewController?.popUpView?.removeFromSuperview()
            self.viewController?.popUpView = nil
        }
    }
    
    func showLoadingBox() {
        guard let vcView = viewController?.view else { return }
        let loadingBox = CMLoadingBox()
        loadingBox.load(in: vcView, message: "Adding New List...")
        self.viewController?.loadingBox = loadingBox
    }
    
    func hideLoadingBox(success: Bool, message: String) {
        self.viewController?.loadingBox?.changeState(success: success, message: message, delay: 2) { [weak self] in
            guard let self = self else { return }
            self.hidePopUp()
            self.viewController?.loadingBox?.removeFromSuperview()
            self.viewController?.loadingBox = nil
        }
    }
}
