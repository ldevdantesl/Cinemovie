//
//  UserServiceImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 2.05.2025.
//

import Foundation

protocol UserServiceProtocol {
    var userLanguage: String { get }
    
    func changeLanguage(to language: String)
}

final class CMUserService: UserServiceProtocol {
    private(set) var userLanguage: String = "en-US"
    
    func changeLanguage(to language: String) {
        self.userLanguage = language
        CMStorage.save(language, key: userLanguageKey)
    }
    
    func addToRecentlyViewedMedia(_ media: Media) {
        guard !recentlyViewedMedia.contains(where: { $0.id == media.id }) else { return }
        self.recentlyViewedMedia.append(media)
        CMStorage.save(recentlyViewedMedia.map(AnyMedia.init), key: recentlyViewedMediaKey)
    }
    
    func addToRecentlySearchedKeywords(_ keyword: String) {
        guard !recentlySearchedKeywords.contains(keyword) else { return }
        self.recentlySearchedKeywords.append(keyword)
        CMStorage.save(recentlySearchedKeywords, key: recentlySearchedKeywordsKey)
    }
}
