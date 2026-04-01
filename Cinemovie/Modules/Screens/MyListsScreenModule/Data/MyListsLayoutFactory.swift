//
//  MyListsLayoutFactory.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.03.2026.
//

import UIKit

enum MyListsLayoutFactory {
    static func make(sectionStore: CMDiffableSectionStore<MyListsScreenVC.Sections>) -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)),
            elementKind: MyListsScreenVC.SupplementaryKind.headerBlur,
            alignment: .topLeading
        )
        globalHeader.pinToVisibleBounds = true
        globalHeader.extendsBoundary = false
        config.boundarySupplementaryItems = [globalHeader]

        return UICollectionViewCompositionalLayout(sectionProvider: { index, env in
            let section = sectionStore.section(at: index)
            switch section {
            case .unauthorized:
                return Self.makeUnauthorizedSection(env: env)
            default:
                return Self.makeDefaultSection()
            }
        }, configuration: config)
    }

    // MARK: - Section Layouts
    private static func makeUnauthorizedSection(env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = []
        return section
    }

    private static func makeDefaultSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension: .estimated(200))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200)),
            subitem: item, count: 2
        )
        group.interItemSpacing = .fixed(20)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)

        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)),
            elementKind: MyListsScreenVC.SupplementaryKind.headerItem,
            alignment: .topLeading
        )
        headerItem.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [headerItem]
        return section
    }

    // MARK: - Standalone
    static func make() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)),
            elementKind: MyListsScreenVC.SupplementaryKind.headerBlur,
            alignment: .topLeading
        )
        globalHeader.pinToVisibleBounds = true
        globalHeader.extendsBoundary = false
        config.boundarySupplementaryItems = [globalHeader]

        return UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ in Self.makeDefaultSection() },
            configuration: config
        )
    }
}
