//
//  MovieDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

import UIKit

protocol MovieDetailsScreenViewProtocol: AnyObject {
}

final class MovieDetailsScreenVC: UIViewController {

    var presenter: MovieDetailsScreenPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
    }
}

extension MovieDetailsScreenVC: MovieDetailsScreenViewProtocol {
}
