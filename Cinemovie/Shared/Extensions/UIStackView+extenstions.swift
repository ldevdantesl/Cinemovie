//
//  UIStackView+extenstions.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 15.05.2025.
//

import UIKit

extension UIStackView {
    func clear() {
        self.arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
