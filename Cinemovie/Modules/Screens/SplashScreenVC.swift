//
//  SplashScreenVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import UIKit
import SnapKit

final class SplashScreenVC: UIViewController {

    private let appLogo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: ImageNames.logoTransparent.rawValue)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        animateLogo()
    }
    
    private func setup() {
        view.backgroundColor = .systemBackground
        view.addSubview(appLogo)
        
        appLogo.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(150)
        }
    }
    
    private func animateLogo() {
        UIView.animate(
            withDuration: 1.2,
            delay: 0,
            options: [.autoreverse, .repeat, .curveEaseInOut],
            animations: {
                self.appLogo.transform = CGAffineTransform(translationX: 0, y: 20)
            },
            completion: nil
        )
    }
}
