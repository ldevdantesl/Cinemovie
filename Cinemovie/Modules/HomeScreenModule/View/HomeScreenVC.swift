//
//  HomeScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol HomeScreenViewProtocol: AnyObject {
}

final class HomeScreenVC: UIViewController {

    var presenter: HomeScreenPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension HomeScreenVC: HomeScreenViewProtocol {
}
