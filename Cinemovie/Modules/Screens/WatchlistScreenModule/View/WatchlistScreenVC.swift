//
//  WatchlistScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

protocol WatchlistScreenViewProtocol: AnyObject {}

final class WatchlistScreenVC: UIViewController {

    var presenter: WatchlistScreenPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension WatchlistScreenVC: WatchlistScreenViewProtocol {}
