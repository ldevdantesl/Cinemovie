//
//  AddToListModalRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 15.05.2025
//
import UIKit

protocol AddToListModalRouterProtocol {
    func goBack()
}

final class AddToListModalRouter: AddToListModalRouterProtocol {
    weak var viewController: AddToListModalVC?
    
    func goBack() {
        viewController?.dismiss(animated: true)
    }
}
