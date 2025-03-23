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
    func didGetAllPersonData(
        _ details: PersonDetails, sources: ExternalSource,
        movies: [Movie], tvShows: [TVSeries]
    )
}

final class PersonDetailsScreenVC: UIViewController {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let collectionViewSpacing = 10.0
        static let aniDuration = 1.0
        static let defaultCellHeight = 100.0
    }
    
    // MARK: - VIPER
    var presenter: PersonDetailsScreenPresenterProtocol?
    
    // MARK: - PROPERTIES
    private var viewModels: [PersonDetailsCellViewModel] = []
    private var cachedCollectionViewCellSize: [IndexPath : CGSize] = [:]
    
    // MARK: - VIEW PROPERTIES
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
        cv.register(PersonDetailsMediaView.self, forCellWithReuseIdentifier: PersonDetailsMediaView.identifier)
        cv.register(PersonDetailsBiographyView.self, forCellWithReuseIdentifier: PersonDetailsBiographyView.identifier)
        cv.register(PersonDetailsSourcesView.self, forCellWithReuseIdentifier: PersonDetailsSourcesView.identifier)
        cv.register(PersonDetailsInfoView.self, forCellWithReuseIdentifier: PersonDetailsInfoView.identifier)
        cv.register(PersonDetailsHeaderView.self, forCellWithReuseIdentifier: PersonDetailsHeaderView.identifier)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadingView.animateLogo()
    }
    
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
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = viewModels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.identifier, for: indexPath)
        
        switch viewModel {
        case let vm as PersonDetailsBiographyViewModel: (cell as? PersonDetailsBiographyView)?.configure(viewModel: vm)
        case let vm as PersonDetailsMediaViewModel: (cell as? PersonDetailsMediaView)?.configure(viewModel: vm)
        case let vm as PersonDetailsSourcesViewModel: (cell as? PersonDetailsSourcesView)?.configure(viewModel: vm)
        case let vm as PersonDetailsHeaderViewModel: (cell as? PersonDetailsHeaderView)?.configure(viewModel: vm)
        case let vm as PersonDetailsInfoViewModel: (cell as? PersonDetailsInfoView)?.configure(viewModel: vm)
        default: return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let cachedSize = cachedCollectionViewCellSize[indexPath] {
            return cachedSize
        }
        
        let viewModel = viewModels[indexPath.row]
        let width = collectionView.frame.width
        
        let size: CGSize
        switch viewModel {
        case let vm as PersonDetailsBiographyViewModel: size = CGSize(width: width - 20, height: vm.cellHeight)
        case is PersonDetailsHeaderViewModel: size = CGSize(width: width - 20, height: 200)
        case is PersonDetailsMediaViewModel: size = CGSize(width: width - 20, height: 220)
        case let vm as PersonDetailsInfoViewModel: size = CGSize(width: width - 20, height: vm.cellHeight)
        case is PersonDetailsSourcesViewModel: size = CGSize(width: width - 30, height: 30)
        default: size = CGSize(width: width - 20, height: Constants.defaultCellHeight)
        }
        
        self.cachedCollectionViewCellSize[indexPath] = size
        return size
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
            presenter?.didTapBackButton()
        }

        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func didGetAllPersonData(
        _ details: PersonDetails, sources: ExternalSource,
        movies: [Movie], tvShows: [TVSeries]
    ) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: Constants.aniDuration, delay: Constants.aniDuration, options: .showHideTransitionViews) { [weak self] in
                guard let self = self else { return }
                self.downloadingView.alpha = 0
            } completion: { [weak self] _ in
                guard let self = self else { return }
                self.downloadingView.isHidden = true
            }
        }
        
        viewModels.append(PersonDetailsHeaderViewModel(
            imagePath: details.profilePath, didTapAvaImage: nil,
            didTapBackButton: presenter?.didTapBackButton
        ))
     
        viewModels.append(PersonDetailsInfoViewModel(
            name: details.name, job: details.knownForDepartment,
            birthday: details.birthday, hometown: details.placeOfBirth,
            gender: details.gender
        ))
    
        !details.biography.isEmpty ? viewModels.append(PersonDetailsBiographyViewModel(biography: details.biography)) : ()
        viewModels.append(PersonDetailsSourcesViewModel(externalSource: sources, didTapLogo: presenter?.didTapLogoImage))
        
        !movies.isEmpty ? viewModels.append(PersonDetailsMediaViewModel(headerTitle: "Movies", headerSubtitle: "Movies in which \(details.name) has played", movies: movies, didTapMovieAction: presenter?.didTapMovie)) : ()
        !tvShows.isEmpty ? viewModels.append(PersonDetailsMediaViewModel(headerTitle: "TV Shows", headerSubtitle: "TV Shows in which \(details.name) has played", tvShows: tvShows, didTapTVShowAction: presenter?.didTapTVSeries)) : ()
        
        DispatchQueue.main.async {
            self.collectionView.setNeedsLayout()
            self.collectionView.layoutIfNeeded()
            self.collectionView.reloadData()
        }
    }
}
