//
//  SettingsLayoutFactory.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.04.2026.
//

import UIKit

enum SettingsLayoutFactory {
    static func make(sectionStore: CMDiffableSectionStore<SettingsScreenVC.Sections>) -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { index, env in
            let section = sectionStore.section(at: index)
            switch section {
            case .header: return Self.makeHeader()
            case .account: return Self.makeAccount()
            default: return Self.makeDefault()
            }
        }
    }
    
    static func makeHeader() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: item.layoutSize,
            subitems: [item]
        )
        let layoutSection = NSCollectionLayoutSection(group: group)
        layoutSection.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        return layoutSection
    }
    
    static func makeDefault() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1000)))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: item.layoutSize,
            subitems: [item]
        )
        let layoutSection = NSCollectionLayoutSection(group: group)
        layoutSection.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        return layoutSection
    }
    
    static func makeAccount() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)),
            subitems: [item]
        )
        
        let layoutSection = NSCollectionLayoutSection(group: group)
        layoutSection.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        return layoutSection
    }
}
