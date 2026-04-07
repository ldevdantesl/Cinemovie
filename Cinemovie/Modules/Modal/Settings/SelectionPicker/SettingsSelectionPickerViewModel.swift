//
//  SettingsSelectionPickerModalViewModel.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.04.2026.
//

import Foundation

final class SettingsSelectionPickerViewModel {
    
    // MARK: - TYPE
    enum PickerType {
        case language
        case region
    }
    
    // MARK: - INJECTED
    private let pickerType: PickerType
    private let networkService: NetworkServiceProtocol
    private let userService: UserServiceProtocol
    
    // MARK: - STATE
    private var allItems: [SettingsModalSelectionCellViewModel] = []
    private(set) var filteredItems: [SettingsModalSelectionCellViewModel] = []
    private var languages: [ConfigurationLanguage] = []
    private var countries: [ConfigurationCountry] = []
    
    // MARK: - COMPUTED
    var searchPlaceholder: String {
        switch pickerType {
        case .language: return "Search languages..."
        case .region:   return "Search regions..."
        }
    }
    
    var title: String {
        switch pickerType {
        case .language: return "Language"
        case .region:   return "Region"
        }
    }
    
    // MARK: - INIT
    init(
        pickerType: PickerType,
        networkService: NetworkServiceProtocol,
        userService: UserServiceProtocol,
    ) {
        self.pickerType = pickerType
        self.networkService = networkService
        self.userService = userService
    }
    
    // MARK: - FUNC
    func loadData() async throws {
        switch pickerType {
        case .language:
            languages = try await networkService.config.getLanguages()
            allItems = languages.map {
                .init(name: $0.englishName,
                      code: $0.iso_639_1,
                      flag: "🌐",
                      isSelected: $0.iso_639_1 == userService.userLanguage.iso_639_1)
            }
        case .region:
            countries = try await networkService.config.getCountries()
            allItems = countries.map {
                .init(name: $0.englishName,
                      code: $0.iso_3166_1,
                      flag: $0.iso_3166_1.flagEmoji,
                      isSelected: $0.iso_3166_1 == userService.region.iso_3166_1)
            }
        }
        filteredItems = allItems
    }
    
    func filter(by searchText: String) {
        if searchText.isEmpty {
            filteredItems = allItems
        } else {
            filteredItems = allItems.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.code.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func selectItem(at index: Int) {
        let tappedCode = filteredItems[index].code
        
        for i in allItems.indices {
            allItems[i].isSelected = allItems[i].code == tappedCode
        }
        for i in filteredItems.indices {
            filteredItems[i].isSelected = filteredItems[i].code == tappedCode
        }
        
        switch pickerType {
        case .language:
            guard let selected = languages.first(where: { $0.iso_639_1 == tappedCode })
            else { return }
            userService.userLanguage = selected
        case .region:
            guard let selected = countries.first(where: { $0.iso_3166_1 == tappedCode })
            else { return  }
            userService.region = selected
        }
    }
}

extension SettingsSelectionPickerViewModel {
    enum SelectionResult {
        case language(ConfigurationLanguage)
        case region(ConfigurationCountry)
    }
}
