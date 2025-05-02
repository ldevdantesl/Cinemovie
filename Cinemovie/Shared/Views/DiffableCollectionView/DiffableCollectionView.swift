//
//  CMCollectionView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 26.03.2025.
//

import UIKit
import SnapKit

final class DiffableCollectionView<Section: Hashable, Item: Hashable>: TopBlurredCollectionView {
    // MARK: - TYPEALIASES
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    // MARK: - PROPERTIES
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var didSelectHandler: ((IndexPath) -> Void)?
    
    // MARK: - LIFECYCLE
    override init(layout: UICollectionViewLayout, ignoresTopSafeArea: Bool = true, showsTopBlur: Bool = true) {
        super.init(layout: layout, ignoresTopSafeArea: ignoresTopSafeArea, showsTopBlur: showsTopBlur)
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
    
    public func setDidSelectHandler(_ handler: @escaping (IndexPath) -> Void) {
        self.didSelectHandler = handler
        self.delegate = self
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let handler = self.didSelectHandler {
            handler(indexPath)
        }
    }
    
    public func applySnapshot(sections: [Section], itemsBySection: [Section: [Item]]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        for section in sections {
            snapshot.appendSections([section])
            snapshot.appendItems(itemsBySection[section] ?? [], toSection: section)
        }
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    public func applySnapshot(snapshot: NSDiffableDataSourceSnapshot<Section, Item>) {
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    public func snapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        return diffableDataSource.snapshot()
    }
    
    public func registerSupplementaryHeaderItem<Cell: ReusableCellBaseClass>(cellClass: Cell.Type) {
        self.register(cellClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellClass.identifier)
    }
    
    public func registerSupplementaryFooterItem<Cell: ReusableCellBaseClass>(cellClass: Cell.Type) {
        self.register(cellClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: cellClass.identifier)
    }
}
