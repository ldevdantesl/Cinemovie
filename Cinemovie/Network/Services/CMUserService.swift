//
//  UserServiceImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 2.05.2025.
//

import Foundation

protocol UserServiceProtocol: AnyObject {
    var userLanguage: ConfigurationLanguage { get set }
    var region: ConfigurationCountry { get set  }
    var notificationEnabled: Bool { get set }
    var adultEnabled: Bool { get set }
    var defaultMediaType: MediaTypes { get set }
    
    func reset()
}

final class CMUserService: UserServiceProtocol {
    
    // MARK: - KEYS
    private let userLanguageKey = "userLanguageKey"
    private let regionKey = "regionKey"
    private let defaultMediaTypeKey = "defaultMediaTypeKey"
    private let notificationEnabledKey = "notificationEnabledKey"
    private let adultEnabledKey = "adultEnabledKey"
    
    // MARK: - PROTOCOL PROPERTIES
    var userLanguage: ConfigurationLanguage {
        didSet {
            CMStorage.save(userLanguage, key: userLanguageKey)
        }
    }
    
    var region: ConfigurationCountry {
        didSet {
            CMStorage.save(region, key: regionKey)
        }
    }
    
    var notificationEnabled: Bool {
        didSet {
            CMStorage.save(notificationEnabled, key: notificationEnabledKey)
        }
    }
    
    var adultEnabled: Bool {
        didSet {
            CMStorage.save(adultEnabled, key: adultEnabledKey)
        }
    }
    
    var defaultMediaType: MediaTypes {
        didSet {
            CMStorage.save(defaultMediaType, key: defaultMediaTypeKey)
        }
    }
    
    // MARK: - INIT
    init() {
        self.userLanguage = CMStorage.load(ConfigurationLanguage.self, key: userLanguageKey) ?? ConfigurationLanguage.english
        self.region = CMStorage.load(ConfigurationCountry.self, key: regionKey) ?? ConfigurationCountry.USA
        self.defaultMediaType = CMStorage.load(MediaTypes.self, key: defaultMediaTypeKey) ?? .movie
        self.notificationEnabled = CMStorage.load(Bool.self, key: notificationEnabledKey) ?? true
        self.adultEnabled = CMStorage.load(Bool.self, key: adultEnabledKey) ?? false
    }
    
    // MARK: - PUBLIC FUNC
    func reset() {
        self.userLanguage = .english
        self.region = .USA
        self.notificationEnabled = true
        self.adultEnabled = false
    }
}
