//
//  PersonDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 20.03.2025
//

import UIKit
import SnapKit

protocol PersonDetailsScreenViewProtocol: AnyObject {
    func didRecieveError(_ errorStr: String)
    func didGetPersonDetails(_ details: PersonDetails)
}

final class PersonDetailsScreenVC: UIViewController {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let collectionViewSpacing = 10.0
        static let aniDuration = 1.0
    }
    
    // MARK: - VIPER
    var presenter: PersonDetailsScreenPresenterProtocol?
    
    // MARK: - PROPERTIES
    private let downloadingView: CMSplashView = {
        let splash = CMSplashView(frame: .zero, showsLoadingLabel: true)
        splash.translatesAutoresizingMaskIntoConstraints = false
        return splash
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.collectionViewSpacing
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = CMColor.cmBackground
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - PUBLIC FUNC
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        view.addSubview(downloadingView)
        downloadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.bringSubviewToFront(downloadingView)
    }
}

extension PersonDetailsScreenVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension PersonDetailsScreenVC: PersonDetailsScreenViewProtocol {
    func didRecieveError(_ errorStr: String) {
        let alert = UIAlertController(
            title: "Oops..",
            message: errorStr,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }

        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func didGetPersonDetails(_ details: PersonDetails) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: Constants.aniDuration, delay: Constants.aniDuration, options: .showHideTransitionViews) { [weak self] in
                guard let self = self else { return }
                self.downloadingView.alpha = 0
            } completion: { [weak self] _ in
                guard let self = self else { return }
                self.downloadingView.isHidden = true
            }
        }
        print(details.name)
    }
}
