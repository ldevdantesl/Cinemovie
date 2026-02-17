//
//  TextFormatter.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 26.02.2025.
//

import UIKit

public struct CMTextFormatter {
    static func formatToCleanString(_ text: String?) -> String {
        guard let text = text else { return "" }
        return text.replacingOccurrences(of: "«", with: "").replacingOccurrences(of: "»", with: "")
    }
    
    static func setHTMLText(_ text: String) -> NSAttributedString? {
        guard let data = text.data(using: .utf8) else { return nil }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        return try? NSAttributedString(data: data, options: options, documentAttributes: nil)
    }
}
