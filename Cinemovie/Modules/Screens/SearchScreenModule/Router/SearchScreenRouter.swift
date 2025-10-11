//
//  SearchScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 13.06.2025
//

import UIKit

protocol SearchScreenRouterProtocol {
    func popBack()
    func pushToMedia(media: Media)
}

final class SearchScreenRouter: SearchScreenRouterProtocol {
    weak var viewController: SearchScreenVC?
    
    func popBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func pushToMedia(media: any Media) {
        print("Media id: \(media.id)")
    }
}
