//
//  TVSeriesDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit

protocol TVSeriesDetailsScreenViewProtocol: AnyObject {
}

final class TVSeriesDetailsScreenVC: UIViewController {

    var presenter: TVSeriesDetailsScreenPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TVSeriesDetailsScreenVC: TVSeriesDetailsScreenViewProtocol {
}
