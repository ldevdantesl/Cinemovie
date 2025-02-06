//
//  ImagePathHelper.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

struct ImagePathURLHelper {
    enum ImageSizes: String {
        case w92 = "w92"
        case w154 = "w154"
        case w185 = "w185"
        case w342 = "w342"
        case w500 = "w500"
        case w780 = "w780"
        case w1280 = "w1280"
        case original = "original"
    }
    
    static func getImageURL(with path: String?, size: ImageSizes) -> URL? {
        guard let path = path else { return nil }
        let finalPath = "\(Constants.imageBaseURLString)/\(size.rawValue)/\(path)"
        return URL(string: finalPath)
    }
}
