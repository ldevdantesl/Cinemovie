//
//  SearchScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol SearchScreenViewProtocol: AnyObject {
}

final class SearchScreenVC: UIViewController {

    var presenter: SearchScreenPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemMint
    }
}

extension SearchScreenVC: SearchScreenViewProtocol {
}
