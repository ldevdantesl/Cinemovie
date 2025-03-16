//
//  CMFont.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

public enum CMFontSizes: CGFloat {
    case title = 24
    case subtitle = 18
    case body = 16
    case caption = 14
    case footnote = 12
    case tiny = 10
}

public enum CMFontNames: String {
    case avenir = "AvenirNext-DemiBold"
    case avenirBold = "AvenirNext-Bold"
}

public struct CMFont {
    static func font(size: CMFontSizes, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: size.rawValue, weight: weight)
    }
    
    static func font(size: CMFontSizes, fontName: CMFontNames) -> UIFont {
        return UIFont(name: fontName.rawValue, size: size.rawValue) ?? UIFont().withSize(size.rawValue)
    }
}
