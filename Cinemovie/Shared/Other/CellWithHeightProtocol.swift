//
//  CellViewModelWithHeightBaseClass.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.04.2025.
//

import Foundation

protocol CellWithHeightProtocol: AnyObject {
    var cellHeight: CGFloat { get set }
    
    func setCellHeight(to height: CGFloat)
}
