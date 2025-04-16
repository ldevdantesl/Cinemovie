//
//  SeasonsPopUpView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 15.04.2025.
//

import UIKit

struct SeasonsPopUpViewModel: PopUPViewModel {
    let didTapClose: (() -> Void)?
}

final class SeasonsPopUpView: PopUPView {
    // MARK: - CONSTANTS
    fileprivate enum Constants { }
    
    // MARK: - PROPERTIES
    private let viewModel: SeasonsPopUpViewModel
    
    // MARK: - VIEW PROPERTIES
    
    // MARK: - LIFECYCLE
    init(viewModel: SeasonsPopUpViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() { }
}
