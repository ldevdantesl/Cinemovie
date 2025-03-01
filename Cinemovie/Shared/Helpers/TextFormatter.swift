//
//  TextFormatter.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 26.02.2025.
//

import UIKit

public struct TextFormatter {
    static func formatToCleanString(_ text: String) -> String {
        return text.replacingOccurrences(of: "«", with: "").replacingOccurrences(of: "»", with: "")
    }
}
