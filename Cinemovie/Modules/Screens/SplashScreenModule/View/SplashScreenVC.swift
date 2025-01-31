//
//  SplashScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit
import SnapKit

protocol SplashScreenViewProtocol: AnyObject { }

final class SplashScreenVC: UIViewController {
    
    var presenter: SplashScreenPresenter?
    
    private let logoImg: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: ImageNames.logoTransparent.rawValue)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoaded()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemRed
        
        view.addSubview(logoImg)
    
        logoImg.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
            $0.height.width.equalTo(150)
        }
    }
}
extension SplashScreenVC: SplashScreenViewProtocol { }
