//
//  ReusableProtocol.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.02.2025.
//

import UIKit

protocol ReusableCell {
    associatedtype ViewModel: CellViewModel
    static var identifier: String { get }
    func configure(with viewModel: ViewModel)
}

extension ReusableCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
