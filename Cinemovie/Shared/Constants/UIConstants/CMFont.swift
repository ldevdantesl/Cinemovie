//
//  CMFont.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

enum CMFontSizes {
    case title
    case subtitle
    case body
    case caption
    case footnote
    case tiny
    case custom(CGFloat)
    
    var value: CGFloat {
        switch self {
        case .title: return 24
        case .subtitle: return 18
        case .body: return 16
        case .caption: return 14
        case .footnote: return 12
        case .tiny: return 10
        case .custom(let float): return float
        }
    }
}

public enum CMFontNames: String {
    case avenirUltraLight = "AvenirNext-UltraLight"
    case avenirRegular = "AvenirNext-Regular"
    case avenirMedium = "AvenirNext-Medium"
    case avenirDemiBold = "AvenirNext-DemiBold"
    case avenirBold = "AvenirNext-Bold"
    case avenirHeavy = "AvenirNext-Heavy"
    case avenirItalic = "AvenirNext-Italic"
    case avenirBoldItalic = "AvenirNext-BoldItalic"
    case avenirDemiBoldItalic = "AvenirNext-DemiBoldItalic"
    case avenirMediumItalic = "AvenirNext-MediumItalic"
    case avenirHeavyItalic = "AvenirNext-HeavyItalic"
    case avenirUltraLightItalic = "AvenirNext-UltraLightItalic"
}

public struct CMFont {
    static func font(size: CMFontSizes, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: size.value, weight: weight)
    }
    
    static func font(size: CMFontSizes, fontName: CMFontNames) -> UIFont {
        return UIFont(name: fontName.rawValue, size: size.value) ?? UIFont().withSize(size.value)
    }
}
