//
//  AddToListModalRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 15.05.2025
//
import UIKit

protocol AddToListModalRouterProtocol {
    func goBack()
    func showLoadingBox()
    func dismissLoadBox(success: Bool, message: String)
}

final class AddToListModalRouter: AddToListModalRouterProtocol {
    weak var viewController: AddToListModalVC?
    
    func goBack() {
        viewController?.dismiss(animated: true)
    }
    
    func showLoadingBox() {
        guard let view = viewController?.view else { return }
        let box = CMLoadingBox()
        box.load(in: view, message: "Adding To the list...")
        viewController?.loadingBox = box
    }
    
    func dismissLoadBox(success: Bool, message: String) {
        viewController?.loadingBox?.changeState(success: success, message: message, delay: 2) { [weak self] in
            guard let self = self else { return }
            self.goBack()
            self.viewController?.loadingBox?.removeFromSuperview()
            self.viewController?.loadingBox = nil
        }
    }
}
