//
//  Collection+Extensions.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.03.2025.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
