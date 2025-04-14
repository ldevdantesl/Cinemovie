//
//  UILabel+Extensions.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 14.04.2025.
//

import UIKit

extension UILabel {
    func calculateLineCount(using font: UIFont) -> Int {
        guard let text = self.text else { return 0 }
        let width = self.bounds.width
        if width == 0 { self.layoutIfNeeded() }

        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let textHeight = NSString(string: text).boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        ).height

        return Int(ceil(textHeight / font.lineHeight))
    }
}
