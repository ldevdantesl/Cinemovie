//
//  PersonDetailsMediaView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 21.03.2025.
//

import UIKit

struct PersonDetailsMediaViewModel: PersonDetailsCellViewModel {
    let identifier: String = "PersonDetailsMediaView"
    let headerTitle: String
    let headerSubtitle: String?
    let movies: [QueryMovie]
}

final class PersonDetailsMediaView: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants { }
    
    // MARK: - STATIC
    static let identifier = "PersonDetailsMediaView"
    
    // MARK: - PROPERTIES
    private var viewModel: PersonDetailsMediaViewModel?
    
    private lazy var movieListView: CMMovieList = {
        let view = CMMovieList()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    public func configure(viewModel: PersonDetailsMediaViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() { }
}
