//
//  MessageBoxView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 16.05.2025.
//

import UIKit
import SnapKit

final class CMLoadingBox: UIView {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let hSpacing = 10.0
        static let spacing = 5.0
        static let containerHeight = 60.0
        static let farOffset = 100.0
        static let loadingImageSize = 45.0
        static let imageSize = 30.0
        static let containerCornerRadius = 15.0
    }
    
    // MARK: - VIEW PROPERTIES
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = CMColor.cmSecondaryBackground
        view.clipsToBounds = true
        return view
    }()
    
    private let stateImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: ImageNames.logoTransparent.rawValue)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.text = "Loading..."
        label.numberOfLines = 1
        label.textColor = CMColor.cmLabel
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenirMedium)
        label.text = "Preparing your experience..."
        label.numberOfLines = 1
        label.textColor = CMColor.cmSublabel
        return label
    }()
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("LoadingBox is deinited")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = Constants.containerCornerRadius
    }
    
    // MARK: - PUBLIC FUNC
    public func load(in superView: UIView) {
        superView.addSubview(self)
        self.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.alpha = 0

        self.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(Constants.containerHeight)
            $0.bottom.equalToSuperview().offset(Constants.farOffset)
        }
        self.layoutIfNeeded()

        containerView.snp.remakeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(Constants.containerHeight)
        }

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.alpha = 1
            self.layoutIfNeeded()
        }
        
        animateImageView()
    }
    
    public func changeState(success: Bool, message: String, onCompletion: (() -> Void)? = nil) {
        stopImageViewAnimation()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.transition(with: self.containerView, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
                guard let self = self else { return }
                self.stateImageView.image = UIImage(named: success ? ImageNames.completed.rawValue : ImageNames.error.rawValue)
                self.stateImageView.snp.updateConstraints {
                    $0.size.equalTo(Constants.imageSize)
                }
                self.stateLabel.text = success ? "Successfully completed" : "Something went wrong"
                self.messageLabel.text = message
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            self.hide(onCompletion: onCompletion)
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setup() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        containerView.addSubview(stateImageView)
        stateImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
            $0.size.equalTo(Constants.loadingImageSize)
        }
        
        containerView.addSubview(stateLabel)
        stateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-Constants.hSpacing)
            $0.leading.equalTo(stateImageView.snp.trailing).offset(Constants.hSpacing)
            $0.trailing.equalToSuperview().offset(-Constants.spacing)
        }
        
        containerView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(stateLabel.snp.bottom)
            $0.leading.equalTo(stateImageView.snp.trailing).offset(Constants.hSpacing)
            $0.trailing.equalToSuperview().offset(-Constants.spacing)
        }
    }
    
    private func animateImageView() {
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.fromValue = -4
        animation.toValue = 4
        animation.duration = 0.8
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        stateImageView.layer.add(animation, forKey: "float")
    }
    
    private func stopImageViewAnimation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.stateImageView.layer.removeAnimation(forKey: "float")
        }
    }
    
    private func hide(onCompletion: (() -> Void)?) {
        containerView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(Constants.containerHeight)
            $0.bottom.equalToSuperview().offset(Constants.farOffset)
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.alpha = 1
            self.layoutIfNeeded()
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.containerView.removeFromSuperview()
            self.removeFromSuperview()
            onCompletion?()
        }
    }
}
