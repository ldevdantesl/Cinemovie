//
//  ImagePathHelper.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

public struct URLHelper {
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
        let finalPath = "\(CONSTANTS.imageBaseURLString)/\(size.rawValue)/\(path)"
        return URL(string: finalPath)
    }
    
    static func getImdbURL(withID id: String) -> URL? {
        return URL(string: "https://www.imdb.com/title/\(id)/")
    }
    
    static func getYouTubeVideoURL(video: DomainVideo, playsInline: Bool = true) -> URL? {
        return URL(string:"https://www.youtube.com/embed/\(video.key)?playsinline=\(playsInline ? "1" : "0")")
    }
}
