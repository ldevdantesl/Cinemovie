//
//  CMSplashView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 16.03.2025.
//

import UIKit
import SnapKit

final class CMSplashView: UIView {
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let appLogoSize: CGFloat = 150
        static let appLogoTranslationY: CGFloat = 20
        static let aniDuration: TimeInterval = 1.2
        static let showAniDuration: TimeInterval = 0.2
    }
    
    // MARK: - VIEW PROPERTIES
    private let appLogo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: ImageNames.logoTransparent.rawValue)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(frame: CGRect, showsLoadingLabel: Bool) {
        self.init(frame: frame)
        showsLoadingLabel ? setupLoadingLabel() : ()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC FUNC
    public func show() {
        self.isHidden = false
        self.alpha = 0
        UIView.animate(withDuration: Constants.showAniDuration, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.alpha = 1
        }
        self.appLogo.transform = .identity
        DispatchQueue.main.async {
            UIView.animate(withDuration: Constants.aniDuration, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut]) { [weak self] in
                guard let self = self else { return }
                self.appLogo.transform = CGAffineTransform(translationX: 0, y: Constants.appLogoTranslationY)
            }
        }
    }
    
    public func hide() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: Constants.aniDuration, delay: Constants.aniDuration, options: .showHideTransitionViews) { [weak self] in
                guard let self = self else { return }
                self.alpha = 0
            } completion: { [weak self] _ in
                guard let self = self else { return }
                self.isHidden = true
            }
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setup() {
        backgroundColor = .clear

        addSubview(blurView)
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }

        addSubview(appLogo)
        appLogo.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(Constants.appLogoSize)
            $0.height.equalTo(Constants.appLogoSize)
        }
    }
    
    private func setupLoadingLabel() {
        let loadingLabel = UILabel()
        loadingLabel.text = "Loading..."
        loadingLabel.textColor = CMColor.cmLabel
        loadingLabel.textAlignment = .center
        loadingLabel.font = CMFont.font(size: .body, fontName: .avenirBold)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(loadingLabel)
        loadingLabel.snp.makeConstraints {
            $0.top.equalTo(appLogo.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}
