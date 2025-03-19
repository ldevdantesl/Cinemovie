//
//  ActorDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 19.03.2025
//

import UIKit

protocol ActorDetailsScreenViewProtocol: AnyObject {
}

final class ActorDetailsScreenVC: UIViewController {

    var presenter: ActorDetailsScreenPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ActorDetailsScreenVC: ActorDetailsScreenViewProtocol {
}
