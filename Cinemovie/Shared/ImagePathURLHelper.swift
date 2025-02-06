//
//  ImagePathHelper.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

struct ImagePathURLHelper {
    protocol ImageSizeProtocol {
        var rawValue: String { get }
    }
    
    enum Backdrop: String, ImageSizeProtocol {
        case w300 = "w300"
        case w780 = "w780"
        case w1280 = "w1280"
        case original = "original"
    }
    
    enum Logo: String, ImageSizeProtocol {
        case w45 = "w45"
        case w92 = "w92"
        case w154 = "w154"
        case w185 = "w185"
        case w300 = "w300"
        case w500 = "w500"
        case original = "original"
    }
    
    enum Poster: String, ImageSizeProtocol {
        case w92 = "w92"
        case w154 = "w154"
        case w185 = "w185"
        case w342 = "w342"
        case w500 = "w500"
        case w780 = "w780"
        case original = "original"
    }
    
    enum Profile: String, ImageSizeProtocol {
        case w45 = "w45"
        case w185 = "w185"
        case h632 = "h632"
        case original = "original"
    }
    
    enum Still: String, ImageSizeProtocol {
        case w92 = "w92"
        case w185 = "w185"
        case w300 = "w300"
        case original = "original"
    }
    
    static func getImageURL<T: RawRepresentable>(with path: String?, size: T) -> URL? where T.RawValue == String {
        guard let path = path else { return nil }
        let finalPath = "\(Constants.imageBaseURLString)/\(size.rawValue)/\(path)"
        return URL(string: finalPath)
    }
}
