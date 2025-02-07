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

    var presenter: HomeScreenPresenterProtocol?
    private var popularMovies: [QueryMovie] = []
    private var upcomingMovies: [QueryMovie] = []
    private var nowPlayingMovies: [QueryMovie] = []
    private var topRatedMovies: [QueryMovie] = []

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = true
        scroll.alwaysBounceVertical = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private lazy var featuredMovieView: CMFeaturedMovie = {
        let movie = CMFeaturedMovie(movies: popularMovies)
        movie.translatesAutoresizingMaskIntoConstraints = false
        return movie
    }()

    private lazy var popularMoviesList: CMMovieList = {
        let list = CMMovieList(movies: popularMovies, listTitle: "Popular Movies", listSubtitle: nil)
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
        featuredMovieView.updateStretchEffect(scrollView: self.scrollView)
    }

    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        view.backgroundColor = CMColor.cmBackground
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(-50)
            $0.leading.trailing.equalTo(scrollView)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.width.equalToSuperview()
        }
        
        contentView.addSubview(featuredMovieView)
        
        featuredMovieView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIConstants.screenHeight*0.7)
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
}

extension HomeScreenVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -view.safeAreaInsets.top {
            scrollView.setContentOffset(CGPoint(x: 0, y: -view.safeAreaInsets.top), animated: false)
            scrollView.isScrollEnabled = false
            UIView.animate(
                withDuration: 0.5, delay: 0.4,
                usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut
            ){
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            } completion: { _ in
                FeedbackGenerator.shared.generate()
                scrollView.isScrollEnabled = true
            }
        }
        featuredMovieView.updateStretchEffect(scrollView: scrollView)
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
}
