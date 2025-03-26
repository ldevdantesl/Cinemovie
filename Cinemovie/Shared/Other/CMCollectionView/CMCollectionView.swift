//
//  CMCollectionView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 26.03.2025.
//

import UIKit

final class CMCollectionView<Section: Hashable, Item: Hashable>: UICollectionView {
    // MARK: - TYPEALIASES
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    // MARK: - PROPERTIES
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    // MARK: - LIFECYCLE
    init(layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: layout)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC FUNC
    public func configureDataSource(cellProvider: @escaping DataSource.CellProvider) {
        self.diffableDataSource = UICollectionViewDiffableDataSource(collectionView: self, cellProvider: cellProvider)
    }
    
    public func setSupplementaryViewProvider(_ provider: @escaping DataSource.SupplementaryViewProvider) {
        self.diffableDataSource.supplementaryViewProvider = provider
    }
    
    public func applySnapshot(sections: [Section], itemsBySection: [Section: [Item]]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        for section in sections {
            snapshot.appendSections([section])
            snapshot.appendItems(itemsBySection[section] ?? [], toSection: section)
        }
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    public func register<Cell: UICollectionViewCell & ReusableCell>(cellClass: Cell.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)
    }
    
    public func registerSupplementaryHeaderItem<Cell: UICollectionViewCell & ReusableCell>(cellClass: Cell.Type) {
        self.register(cellClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellClass.identifier)
    }
    
    public func registerSupplementaryFooterItem<Cell: UICollectionViewCell & ReusableCell>(cellClass: Cell.Type) {
        self.register(cellClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: cellClass.identifier)
    }
}
