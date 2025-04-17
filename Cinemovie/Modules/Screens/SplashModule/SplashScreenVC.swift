//
//  SplashScreenVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import UIKit
import SnapKit

final class SplashScreenVC: UIViewController {

    // MARK: - PROPERTIES
    private lazy var splashView: CMSplashView = {
        let view = CMSplashView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        splashView.show()
    }
    
    private func setup() {
        view.backgroundColor = CMColor.cmError
        view.addSubview(splashView)
        
        splashView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
