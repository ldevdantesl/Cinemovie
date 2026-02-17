//
//  MediaListType.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.04.2025.
//

import Foundation

protocol MediaListType: Hashable, Equatable {
    var title: String { get }
    var subtitle: String { get }
}
