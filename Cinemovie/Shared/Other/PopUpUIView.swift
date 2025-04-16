//
//  PopUpUIView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 15.04.2025.
//

import UIKit
import SnapKit

protocol PopUPViewModel {
    var didTapClose: (() -> Void)? { get }
}

open class PopUPView: UIView {
    // MARK: - PROPERTIES
    private let viewModel: PopUPViewModel
    
    // MARK: - VIEW PROPERTIES
    private lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapClose)))
        return view
    }()
    
    init(viewModel: PopUPViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - PUBLIC FUNC
    func show(in parentView: UIView) {
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
    
    func dismiss() {
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
            self.viewModel.didTapClose?()
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
        self.dismiss()
    }
}
