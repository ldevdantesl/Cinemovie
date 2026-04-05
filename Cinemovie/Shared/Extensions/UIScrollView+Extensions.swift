//
//  UIScrollView+Extensions.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.04.2026.
//

import UIKit

extension UIScrollView {
    var resignsFirstResponderOnScroll: Bool {
        get { keyboardDismissMode != .none }
        set { keyboardDismissMode = newValue ? .onDrag : .none }
    }
}
