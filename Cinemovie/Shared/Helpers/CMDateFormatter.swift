//
//  CMDateFormatter.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 15.03.2025.
//

import Foundation

public struct CMDateFormatter {
    static func formatToNormalDate(dateString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM yyyy"
        outputFormatter.locale = Locale(identifier: "en_US")

        return outputFormatter.string(from: date)
    }
}
