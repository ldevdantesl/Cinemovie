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
    func didTapMovie(_ movie: QueryMovie)
    func didRecieveError(_ errorStr: String)
}

final class HomeScreenVC: UIViewController {

    var presenter: HomeScreenPresenterProtocol?
    private var isShadowVisible = false
    
    private var popularMovies: [QueryMovie] = []
    private var upcomingMovies: [QueryMovie] = []
    private var nowPlayingMovies: [QueryMovie] = []
    private var topRatedMovies: [QueryMovie] = []

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
    
    private lazy var headerView: CMHeaderView = {
        let firstButton = CMCircularButton(
            systemName: "magnifyingglass",
            size: 30,
            backColor: .clear,
            foreColor: .cmLabel,
            target: self,
            action: #selector(didTapSearchButton)
        )
        
        let header = CMHeaderView(
            headerTitle: "For Dantes",
            firstButton: firstButton,
            secondButton: nil
        )
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    private lazy var featuredMovieView: CMFeaturedMovie = {
        let movie = CMFeaturedMovie(movies: popularMovies)
        movie.translatesAutoresizingMaskIntoConstraints = false
        return movie
    }()

    private lazy var popularMoviesList: CMMovieList = {
        let list = CMMovieList(
            movies: popularMovies,
            listTitle: "Popular Movies",
            listSubtitle: nil,
            didTapMovie: didTapMovie
        )
        list.translatesAutoresizingMaskIntoConstraints = false
        list.isUserInteractionEnabled = true
        return list
    }()
    
    private lazy var upcomingMoviesList: CMMovieList = {
        let list = CMMovieList(movies: upcomingMovies, listTitle: "Upcoming Movies", listSubtitle: nil)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.isUserInteractionEnabled = true
        return list
    }()
    
    private lazy var nowPlayingMoviesList: CMMovieList = {
        let list = CMMovieList(movies: nowPlayingMovies, listTitle: "Now Playing Movies", listSubtitle: nil)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.isUserInteractionEnabled = true
        return list
    }()
    
    private lazy var topRatedMoviesList: CMMovieList = {
        let list = CMMovieList(movies: topRatedMovies, listTitle: "Top Rated Movies", listSubtitle: nil)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.isUserInteractionEnabled = true
        return list
    }()

    // MARK: - VC Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoaded()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        featuredMovieView.updateMovie()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        view.backgroundColor = CMColor.cmBackground
    
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        view.bringSubviewToFront(headerView)
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
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
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.height.equalTo(UIConstants.screenHeight * 0.6)
        }
        
        contentView.addSubview(popularMoviesList)
        popularMoviesList.snp.makeConstraints {
            $0.top.equalTo(featuredMovieView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(upcomingMoviesList)
        upcomingMoviesList.snp.makeConstraints {
            $0.top.equalTo(popularMoviesList.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(topRatedMoviesList)
        topRatedMoviesList.snp.makeConstraints {
            $0.top.equalTo(upcomingMoviesList.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(nowPlayingMoviesList)
        nowPlayingMoviesList.snp.makeConstraints {
            $0.top.equalTo(topRatedMoviesList.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(nowPlayingMoviesList.snp.bottom).offset(10)
        }
    }
    
    // MARK: - OBJC FUNCTIONS
    @objc
    private func didTapSearchButton() {
        print("Tapped Search Button")
    }
}

extension HomeScreenVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let shouldShowShadow = scrollView.contentOffset.y >= 10

        if shouldShowShadow != isShadowVisible {
            isShadowVisible = shouldShowShadow

            if shouldShowShadow {
                headerView.addShadowToHeader()
            } else {
                headerView.removeShadowFromHeader()
            }
        }
    }
}

extension HomeScreenVC: HomeScreenViewProtocol {
    func didRecievePopularMovies(_ movies: [QueryMovie]) {
        self.popularMovies = movies
        self.popularMoviesList.updateMovies(movies)
        self.featuredMovieView.updateMovies(movies)
    }
    
    func didRecieveTopRatedMovies(_ movies: [QueryMovie]) {
        self.topRatedMovies = movies
        self.topRatedMoviesList.updateMovies(movies)
    }
    
    func didRecieveUpcomingMovies(_ movies: [QueryMovie]) {
        self.upcomingMovies = movies
        self.upcomingMoviesList.updateMovies(movies)
    }
    
    func didRecieveNowPlayingMovies(_ movies: [QueryMovie]) {
        self.nowPlayingMovies = movies
        self.nowPlayingMoviesList.updateMovies(movies)
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
    
    func didTapMovie(_ movie: QueryMovie) {
        print("Tapped movie: \(movie.title)")
        presenter?.didTapMovie(movie)
    }
}
