//
//  Int+Extensions.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 9.07.2026.
//

import Foundation

extension Int {
    var compactCount: String {
        switch self {
        case ..<1000:
            return "\(self)"
        case ..<1_000_000:
            return Self.trimmed(Double(self) / 1000) + "k"
        default:
            return Self.trimmed(Double(self) / 1_000_000) + "M"
        }
    }

    private static func trimmed(_ value: Double) -> String {
        let rounded = (value * 10).rounded(.down) / 10
        return rounded.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", rounded)
            : String(format: "%.1f", rounded)
    }
}
