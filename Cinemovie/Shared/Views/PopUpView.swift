//
//  PopUpUIView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 15.04.2025.
//

import UIKit
import SnapKit

protocol PopUPViewModel {
    var onClose: (() -> Void)? { get }
}

open class PopUPView: UIView {
    // MARK: - PROPERTIES
    private let viewModel: PopUPViewModel
    private let closesOnBackgroundTap: Bool
    
    // MARK: - VIEW PROPERTIES
    private lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapClose)))
        return view
    }()
    
    init(viewModel: PopUPViewModel, closesOnBackgroundTap: Bool = true) {
        self.viewModel = viewModel
        self.closesOnBackgroundTap = closesOnBackgroundTap
        super.init(frame: .zero)
        setupUI()
    }
    
    deinit {
        print("Pop Up deinited")
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - PUBLIC FUNC
    public func show(in parentView: UIView) {
        parentView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        parentView.addSubview(self)
        self.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) { [weak self] in
            guard let self = self else { return }
            self.alpha = 1
            self.transform = .identity
        }
    }
    
    public func dismiss() {
        UIView.animate(
            withDuration: 0.5, delay: 0,
            usingSpringWithDamping: 0.7, initialSpringVelocity: 1,
            options: .curveEaseOut
        ) { [weak self] in
            guard let self = self else { return }
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).concatenating(CGAffineTransform(translationX: 0, y: 30))
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.removeFromSuperview()
            self.viewModel.onClose?()
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - OBJC
    @objc private func didTapClose() {
        closesOnBackgroundTap ? self.dismiss() : ()
    }
}
