//
//  HomeScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import SnapKit
import UIKit

protocol HomeScreenViewProtocol: AnyObject {
    func didRecievePopularMovies(_ movies: [QueryMovie])
    func didRecieveTopRatedMovies(_ movies: [QueryMovie])
    func didRecieveUpcomingMovies(_ movies: [QueryMovie])
    func didRecieveNowPlayingMovies(_ movies: [QueryMovie])

    func didRecieveError(_ errorStr: String)
}

final class HomeScreenVC: UIViewController {

    // MARK: - CONSTANTS
    fileprivate enum Paddings {
        static let bigSpacing: CGFloat = 10
        static let spacing = 5.0
    }
    
    fileprivate enum Constants {
        static let featuredMovieViewHorPadding = 20
        static let featuredMovieTopPadding: CGFloat = 70
        static let headerViewHeight = 115
        static let featuredMovieHeight = UIConstants.screenHeight * 0.55
        static let mediaListViewHeight: CGFloat = 200
    }
    
    // MARK: - VIPER
    var presenter: HomeScreenPresenterProtocol?
    
    private var lastContentOffset: CGFloat = 0
    
    // MARK: - PROPERTIES
    private var isBlurVisible = false
    
    // MARK: - VIEW PROPERTIES
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = true
        scroll.alwaysBounceVertical = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.delegate = self
        return scroll
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var headerView: HomeScreenHeaderView = {
        let headerVM = HomeScreenHeaderViewModel(headerTitle: "For Dantes")
        let header = HomeScreenHeaderView(viewModel: headerVM)
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    private let featuredMovieView: HomeScreenFeaturedMovieView = {
        let movie = HomeScreenFeaturedMovieView()
        movie.translatesAutoresizingMaskIntoConstraints = false
        return movie
    }()

    private let popularMoviesList: CMMediaListView = {
        let list = CMMediaListView()
        list.translatesAutoresizingMaskIntoConstraints = false
        list.isUserInteractionEnabled = true
        return list
    }()
    
    private let upcomingMoviesList: CMMediaListView = {
        let list = CMMediaListView()
        list.translatesAutoresizingMaskIntoConstraints = false
        list.isUserInteractionEnabled = true
        return list
    }()
    
    private let nowPlayingMoviesList: CMMediaListView = {
        let list = CMMediaListView()
        list.translatesAutoresizingMaskIntoConstraints = false
        list.isUserInteractionEnabled = true
        return list
    }()
    
    private let topRatedMoviesList: CMMediaListView = {
        let list = CMMediaListView()
        list.translatesAutoresizingMaskIntoConstraints = false
        list.isUserInteractionEnabled = true
        return list
    }()

    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoaded()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constants.headerViewHeight)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.trailing.equalTo(scrollView)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.width.equalToSuperview()
        }
        
        contentView.addSubview(featuredMovieView)
        featuredMovieView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(Constants.featuredMovieTopPadding)
            $0.horizontalEdges.equalToSuperview().inset(Paddings.bigSpacing)
            $0.height.equalTo(Constants.featuredMovieHeight)
        }
        
        contentView.addSubview(popularMoviesList)
        popularMoviesList.snp.makeConstraints {
            $0.top.equalTo(featuredMovieView.snp.bottom).offset(Paddings.bigSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Paddings.bigSpacing)
            $0.height.equalTo(Constants.mediaListViewHeight)
        }
        
        contentView.addSubview(upcomingMoviesList)
        upcomingMoviesList.snp.makeConstraints {
            $0.top.equalTo(popularMoviesList.snp.bottom).offset(Paddings.bigSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Paddings.bigSpacing)
            $0.height.equalTo(Constants.mediaListViewHeight)
        }
        
        contentView.addSubview(topRatedMoviesList)
        topRatedMoviesList.snp.makeConstraints {
            $0.top.equalTo(upcomingMoviesList.snp.bottom).offset(Paddings.bigSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Paddings.bigSpacing)
            $0.height.equalTo(Constants.mediaListViewHeight)
        }
        
        contentView.addSubview(nowPlayingMoviesList)
        nowPlayingMoviesList.snp.makeConstraints {
            $0.top.equalTo(topRatedMoviesList.snp.bottom).offset(Paddings.bigSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Paddings.bigSpacing)
            $0.height.equalTo(Constants.mediaListViewHeight)
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(nowPlayingMoviesList.snp.bottom).offset(Paddings.bigSpacing)
        }
    }
}

extension HomeScreenVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerBottomY = headerView.convert(headerView.bounds, to: view).maxY
        let featuredTopY = featuredMovieView.convert(featuredMovieView.bounds, to: view).minY
        
        if headerBottomY >= featuredTopY {
            if !isBlurVisible {
                isBlurVisible = true
                headerView.addBlurToHeader()
            }
        } else {
            if isBlurVisible {
                isBlurVisible = false
                headerView.removeBlurFromHeader()
            }
        }
    }
}

extension HomeScreenVC: HomeScreenViewProtocol {
    func didRecievePopularMovies(_ movies: [QueryMovie]) {
        DispatchQueue.main.async {
            let vm = CMMediaListViewModel(movies: movies, listTitle: "Popular Movies", didTapMovie: self.presenter?.didTapMovie)
            self.popularMoviesList.configure(viewModel: vm)
            let featuredVM = HomeScreenFeaturedMovieViewModel(movies: movies, didTapMovie: self.presenter?.didTapMovie)
            self.featuredMovieView.configure(viewModel: featuredVM)
        }
    }
    
    func didRecieveTopRatedMovies(_ movies: [QueryMovie]) {
        DispatchQueue.main.async {
            let vm = CMMediaListViewModel(movies: movies, listTitle: "Top Rated Movies", didTapMovie: self.presenter?.didTapMovie)
            self.topRatedMoviesList.configure(viewModel: vm)
        }
    }
    
    func didRecieveUpcomingMovies(_ movies: [QueryMovie]) {
        DispatchQueue.main.async {
            let vm = CMMediaListViewModel(movies: movies, listTitle: "Upcoming Movies", didTapMovie: self.presenter?.didTapMovie)
            self.upcomingMoviesList.configure(viewModel: vm)
        }
    }
    
    func didRecieveNowPlayingMovies(_ movies: [QueryMovie]) {
        DispatchQueue.main.async {
            let vm = CMMediaListViewModel(movies: movies, listTitle: "Now Playing Movies", didTapMovie: self.presenter?.didTapMovie)
            self.nowPlayingMoviesList.configure(viewModel: vm)
        }
    }

    func didRecieveError(_ errorStr: String) {
        let alert = UIAlertController(
            title: "Oops..",
            message: errorStr,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "OK", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
}
