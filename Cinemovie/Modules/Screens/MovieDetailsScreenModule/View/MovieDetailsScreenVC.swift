//
//  MovieDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

import UIKit
import SnapKit
import SDWebImage

protocol MovieDetailsScreenViewProtocol: AnyObject {
    func didRecieveError(_ errorStr: String)
    
    func didDownloadAllData(
        details: MovieDetails, videos: [DomainVideo]?,
        cast: [Cast]?, crew: [Cast]?,
        recommends: [QueryMovie]?, reviews: [DomainReview]?,
        reviewCount: Int?
    )
}

final class MovieDetailsScreenVC: UIViewController {

    // MARK: - PADDINGS
    fileprivate enum Paddings { }
    
    // MARK: - CONSTANTS
    fileprivate enum Constants { }
    
    // MARK: - VIPER
    var presenter: MovieDetailsScreenPresenterProtocol?
    
    // MARK: - PROPERTIES
    private lazy var downloadingScreen: CMSplashView = {
        let view = CMSplashView(frame: .zero, showsLoadingLabel: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(downloadingScreen)
        downloadingScreen.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MovieDetailsScreenVC: MovieDetailsScreenViewProtocol {
    func didRecieveError(_ errorStr: String) {
        let alert = UIAlertController(
            title: "Oops..",
            message: errorStr,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "OK", style: .cancel) {_ in
            self.dismiss(animated: true)
        }

        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didDownloadAllData(
        details: MovieDetails, videos: [DomainVideo]?,
        cast: [Cast]?, crew: [Cast]?,
        recommends: [QueryMovie]?, reviews: [DomainReview]?,
        reviewCount: Int?
    ) {
        UIView.animate(withDuration: 1, delay: 1, options: .showHideTransitionViews) { [weak self] in
            guard let self = self else { return }
            self.downloadingScreen.alpha = 0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.downloadingScreen.isHidden = true
        }
    }
}
