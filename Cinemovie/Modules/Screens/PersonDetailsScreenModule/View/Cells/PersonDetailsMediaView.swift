//
//  PersonDetailsMediaView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 21.03.2025.
//

import UIKit

struct PersonDetailsMediaViewModel: PersonDetailsCellViewModel {
    let identifier: String = "PersonDetailsMediaView"
    
}

final class PersonDetailsMediaView: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants { }
    
    // MARK: - STATIC
    static let identifier = "PersonDetailsMediaView"
    
    // MARK: - PROPERTIES
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC FUNC
    public func configure() { }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() { }
    
    // MARK: - OBJC FUNC
}
