//
//  ReusableProtocol.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.02.2025.
//

import UIKit

public class ReusableCellBaseClass: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
