//
//  PaddedLabel.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.05.2025.
//

import UIKit

final class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 15, left: 15, bottom: 5, right: 15)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}
