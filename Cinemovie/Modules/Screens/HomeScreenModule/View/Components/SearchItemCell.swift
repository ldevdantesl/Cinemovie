//
//  SearchItemCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 22.04.2025.
//

import Foundation

final class SearchItemCellViewModel: CellViewModelBaseClass {
    let media: Media
    
    init(media: Media) {
        self.media = media
        super.init(cellIdentifier: "SearchItemCell")
    }
}

final class SearchItemCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants { }
    
    // MARK: - PROPERTIES
    private var viewModel: SearchItemCellViewModel?
    
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
    public func configure(viewModel: SearchItemCellViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() { }
}
