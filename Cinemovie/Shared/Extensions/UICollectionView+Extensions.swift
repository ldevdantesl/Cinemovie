//
//  UICollectionView+Extensions.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 12.04.2025.
//

import UIKit

extension UICollectionView {
    public func register<Cell: UICollectionViewCell>(cellClass: Cell.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)
    }
}
