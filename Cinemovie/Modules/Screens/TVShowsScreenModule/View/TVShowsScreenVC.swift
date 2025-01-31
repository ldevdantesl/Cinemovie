//
//  TVShowsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol TVShowsScreenViewProtocol: AnyObject {
}

final class TVShowsScreenVC: UIViewController {

    var presenter: TVShowsScreenPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TVShowsScreenVC: TVShowsScreenViewProtocol {
}
