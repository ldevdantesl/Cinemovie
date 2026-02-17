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
