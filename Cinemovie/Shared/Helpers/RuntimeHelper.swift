//
//  RuntimeHelper.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 25.02.2025.
//

import UIKit

public struct RuntimeHelper {
    static func runtime(_ runtime: Int) -> String {
        let hours = runtime / 60
        let minutes = runtime % 60
        return "\(hours)h \(minutes)m"
    }
}
