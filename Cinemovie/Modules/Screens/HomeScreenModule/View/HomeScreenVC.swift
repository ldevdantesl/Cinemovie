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
        static let headerViewHeight: CGFloat = 80
        static let featuredMovieViewHorPadding = 20
        static let featuredMovieHeight = UIConstants.screenHeight * 0.55
        static let spacing: CGFloat = 10
    }
    
    fileprivate enum Constants {
        static let headerViewFirstButtonSize: CGFloat = 30
    }
    
    // MARK: - VIPER
    var presenter: HomeScreenPresenterProtocol?
    
    // MARK: - PROPERTIES
    private var isShadowVisible = false
    
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
    
    private lazy var headerView: CMHeaderView = {
        let firstButton = CMCircularButton(
            systemName: "magnifyingglass",
            size: Constants.headerViewFirstButtonSize,
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

    private let featuredMovieView: CMFeaturedMovie = {
        let movie = CMFeaturedMovie()
        movie.translatesAutoresizingMaskIntoConstraints = false
        return movie
    }()

    private let popularMoviesList: CMMovieList = {
        let list = CMMovieList()
        list.translatesAutoresizingMaskIntoConstraints = false
        list.isUserInteractionEnabled = true
        return list
    }()
    
    private let upcomingMoviesList: CMMovieList = {
        let list = CMMovieList()
        list.translatesAutoresizingMaskIntoConstraints = false
        list.isUserInteractionEnabled = true
        return list
    }()
    
    private let nowPlayingMoviesList: CMMovieList = {
        let list = CMMovieList()
        list.translatesAutoresizingMaskIntoConstraints = false
        list.isUserInteractionEnabled = true
        return list
    }()
    
    private let topRatedMoviesList: CMMovieList = {
        let list = CMMovieList()
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
        view.backgroundColor = CMColor.cmBackground
    
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(Paddings.headerViewHeight)
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
            $0.leading.equalTo(contentView.snp.leading).offset(Paddings.featuredMovieViewHorPadding)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-Paddings.featuredMovieViewHorPadding)
            $0.height.equalTo(Paddings.featuredMovieHeight)
        }
        
        contentView.addSubview(popularMoviesList)
        popularMoviesList.snp.makeConstraints {
            $0.top.equalTo(featuredMovieView.snp.bottom).offset(Paddings.spacing)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.addSubview(upcomingMoviesList)
        upcomingMoviesList.snp.makeConstraints {
            $0.top.equalTo(popularMoviesList.snp.bottom).offset(Paddings.spacing)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.addSubview(topRatedMoviesList)
        topRatedMoviesList.snp.makeConstraints {
            $0.top.equalTo(upcomingMoviesList.snp.bottom).offset(Paddings.spacing)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.addSubview(nowPlayingMoviesList)
        nowPlayingMoviesList.snp.makeConstraints {
            $0.top.equalTo(topRatedMoviesList.snp.bottom).offset(Paddings.spacing)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(nowPlayingMoviesList.snp.bottom).offset(Paddings.spacing)
        }
    }
    
    // MARK: - OBJC FUNCTIONS
    @objc private func didTapSearchButton() {
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
        DispatchQueue.main.async {
            let vm = CMMovieListViewModel(movies: movies, listTitle: "Popular Movies", didTapMovie: self.presenter?.didTapMovie)
            self.popularMoviesList.configure(viewModel: vm)
            let featuredVM = CMFeaturedMovieViewModel(movies: movies, didTapMovie: self.presenter?.didTapMovie)
            self.featuredMovieView.configure(viewModel: featuredVM)
        }
    }
    
    func didRecieveTopRatedMovies(_ movies: [QueryMovie]) {
        DispatchQueue.main.async {
            let vm = CMMovieListViewModel(movies: movies, listTitle: "Upcoming Movies", didTapMovie: self.presenter?.didTapMovie)
            self.topRatedMoviesList.configure(viewModel: vm)
        }
    }
    
    func didRecieveUpcomingMovies(_ movies: [QueryMovie]) {
        DispatchQueue.main.async {
            let vm = CMMovieListViewModel(movies: movies, listTitle: "Top Rated Movies", didTapMovie: self.presenter?.didTapMovie)
            self.upcomingMoviesList.configure(viewModel: vm)
        }
    }
    
    func didRecieveNowPlayingMovies(_ movies: [QueryMovie]) {
        DispatchQueue.main.async {
            let vm = CMMovieListViewModel(movies: movies, listTitle: "Now Playing Movies", didTapMovie: self.presenter?.didTapMovie)
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
