//
//  CellViewModel.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 26.03.2025.
//

import UIKit

open class CellViewModelBaseClass: Hashable{
    let id: UUID = UUID()
    let cellIdentifier: String
    
    init(cellIdentifier: String) {
        self.cellIdentifier = cellIdentifier
    }
    
    public static func == (lhs: CellViewModelBaseClass, rhs: CellViewModelBaseClass) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
