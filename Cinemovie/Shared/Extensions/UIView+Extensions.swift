//
//  UIView+Extensions.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.05.2025.
//

import UIKit

extension UIView {
    func clearSubviews() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

extension UIView {
    func animateTap(onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            } completion: { _ in
                onCompletion?()
            }
        }
    }
}

