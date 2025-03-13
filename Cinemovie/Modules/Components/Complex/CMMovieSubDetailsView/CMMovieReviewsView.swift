//
//  CMMovieReviewsView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 13.03.2025.
//

import UIKit

final class CMMovieReviewsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    // MARK: - Private func
    private func setupUI() {
        self.backgroundColor = .cmAccent
    }
}
