//
//  HomeScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit
import SnapKit

protocol HomeScreenViewProtocol: AnyObject {
    func didRecieveMovies(_ movies: [QueryMovie])
    func didRecieveError(_ errorStr: String)
}

final class HomeScreenVC: UIViewController {
    
    var presenter: HomeScreenPresenterProtocol?
    private var popularMovies: [QueryMovie] = []
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let contentView: UIView = UIView()
    
    private let featuredMovieView = CMFeaturedMovie(movie: nil)
    
    // MARK: - VC Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoaded()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !popularMovies.isEmpty {
            updateFeaturedMovie()
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        view.backgroundColor = CMColor.cmBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        contentView.addSubview(featuredMovieView)
        
        featuredMovieView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.5)

        }
        
        let extraContent = UILabel()
        extraContent.text = "More Content Here..."
        extraContent.font = UIFont.boldSystemFont(ofSize: 20)
        extraContent.textAlignment = .center
        extraContent.textColor = .white
        
        contentView.addSubview(extraContent)
        extraContent.snp.makeConstraints {
            $0.top.equalTo(featuredMovieView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func updateFeaturedMovie() {
        guard let firstMovie = popularMovies.randomElement() else { return }
        featuredMovieView.updateMovie(firstMovie)
    }
}

extension HomeScreenVC: HomeScreenViewProtocol {
    func didRecieveMovies(_ movies: [QueryMovie]) {
        self.popularMovies = movies
        DispatchQueue.main.async { [weak self] in
            self?.updateFeaturedMovie()
        }
    }
    
    func didRecieveError(_ errorStr: String) {
        let alert = UIAlertController(
            title: "Oops..",
            message: errorStr,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
