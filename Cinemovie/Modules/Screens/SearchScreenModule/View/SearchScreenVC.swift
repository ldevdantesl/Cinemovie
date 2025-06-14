//
//  SearchScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 13.06.2025
//

import UIKit
import SnapKit

protocol SearchScreenViewProtocol: AnyObject { }

final class SearchScreenVC: UIViewController {

    var presenter: SearchScreenPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CMColor.cmError
    }
}

extension SearchScreenVC: SearchScreenViewProtocol { }
