//
//  PersonDetailsMediaView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 21.03.2025.
//

import UIKit
import SnapKit

struct PersonDetailsMediaViewModel: PersonDetailsCellViewModel {
    let identifier: String = "PersonDetailsMediaView"
    private(set) var isMovieType: Bool
    
    let headerTitle: String
    let headerSubtitle: String?
    let movies: [QueryMovie]
    let tvShows: [QueryTVShow]
    let didTapMovieAction: ((QueryMovie) -> Void)?
    let didTapTVShowAction: ((QueryTVShow) -> Void)?
    
    init(headerTitle: String, headerSubtitle: String?, movies: [QueryMovie], didTapMovieAction: ((QueryMovie) -> Void)? = nil) {
        self.isMovieType = true
        self.headerTitle = headerTitle
        self.headerSubtitle = headerSubtitle
        self.movies = movies
        self.tvShows = []
        self.didTapMovieAction = didTapMovieAction
        self.didTapTVShowAction = nil
    }
    
    init(headerTitle: String, headerSubtitle: String?, tvShows: [QueryTVShow], didTapTVShowAction: ((QueryTVShow) -> Void)? = nil) {
        self.isMovieType = false
        self.headerTitle = headerTitle
        self.headerSubtitle = headerSubtitle
        self.movies = []
        self.tvShows = tvShows
        self.didTapTVShowAction = didTapTVShowAction
        self.didTapMovieAction = nil
    }
}

final class PersonDetailsMediaView: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants { }
    
    // MARK: - STATIC
    static let identifier = "PersonDetailsMediaView"
    
    // MARK: - PROPERTIES
    private var viewModel: PersonDetailsMediaViewModel?
    
    private lazy var mediaListView: CMMediaListView = {
        let view = CMMediaListView()
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
        let vm = viewModel.isMovieType ?
        CMMediaListViewModel(movies: viewModel.movies, listTitle: viewModel.headerTitle, listSubtitle: viewModel.headerSubtitle, didTapMovie: viewModel.didTapMovieAction) :
        CMMediaListViewModel(tvShows: viewModel.tvShows, listTitle: viewModel.headerTitle, listSubtitle: viewModel.headerSubtitle, didTapTVShow: viewModel.didTapTVShowAction)
        self.mediaListView.configure(viewModel: vm)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(mediaListView)
        mediaListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
