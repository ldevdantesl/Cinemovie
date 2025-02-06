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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoaded()
        setupUI()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    func setupUI() {
        let popularMoviesPVC = CMPopularMoviesPVC(movies: popularMovies)
        addChild(popularMoviesPVC)
        view.addSubview(popularMoviesPVC.view)
        popularMoviesPVC.didMove(toParent: self)
        
        popularMoviesPVC.view.translatesAutoresizingMaskIntoConstraints = false
        popularMoviesPVC.view.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(270)
        }
    }
}

extension HomeScreenVC: HomeScreenViewProtocol {
    func didRecieveMovies(_ movies: [QueryMovie]) {
        self.popularMovies = movies
        DispatchQueue.main.async { [weak self] in
            self?.setupUI()
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
