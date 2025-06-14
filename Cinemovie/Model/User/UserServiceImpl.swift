//
//  UserServiceImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 2.05.2025.
//

import Foundation

final class UserServiceImpl: UserService {
    private let defaults = UserDefaults.standard
    
    private(set) var userLanguage: String
    private(set) var recentlyViewedMedia: [Media]
    private(set) var recentlySearchedKeywords: [String]
    
    private let userLanguageKey = "USER-SERVICE:userLanguage"
    private let recentlyViewedMediaKey = "USER-SERVICE:recentlyViewedMedia"
    private let recentlySearchedKeywordsKey = "USER-SERVICE:recentlySearchedKeywords"
    
    init() {
        self.userLanguage = defaults.string(forKey: userLanguageKey) ?? "en-US"
        self.recentlyViewedMedia = CMStorage.load([AnyMedia].self, key: recentlyViewedMediaKey)?
            .compactMap { $0.asMedia } ?? []
        self.recentlySearchedKeywords = CMStorage.load([String].self, key: recentlySearchedKeywordsKey) ?? []
    }
    
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
