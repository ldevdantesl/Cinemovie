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
    
    // MARK: - CONSTANTS
    fileprivate enum Constants { }
    
    // MARK: - VIPER
    var presenter: MovieDetailsScreenPresenterProtocol?
    
    // MARK: - PROPERTIES
    private var viewModels: [MovieDetailsCellViewModel] = []
    
    // MARK: - VIEW PROPERTIES
    private lazy var downloadingScreen: CMSplashView = {
        let view = CMSplashView(frame: .zero, showsLoadingLabel: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = CMColor.cmBackground
        cv.register(MovieDetailsProductionView.self, forCellWithReuseIdentifier: MovieDetailsProductionView.identifier)
        cv.register(MovieSubDetailsView.self, forCellWithReuseIdentifier: MovieSubDetailsView.identifier)
        cv.register(MovieBackdropImageView.self, forCellWithReuseIdentifier: MovieBackdropImageView.identifier)
        cv.register(MovieTitleAndTaglineView.self, forCellWithReuseIdentifier: MovieTitleAndTaglineView.identifier)
        cv.register(MovieDetailsCastList.self, forCellWithReuseIdentifier: MovieDetailsCastList.identifier)
        cv.register(MovieAddToWatchlistAndOverviewView.self, forCellWithReuseIdentifier: MovieAddToWatchlistAndOverviewView.identifier)
        cv.delegate = self
        cv.dataSource = self
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
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(downloadingScreen)
        downloadingScreen.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.bringSubviewToFront(downloadingScreen)
    }
}

extension MovieDetailsScreenVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = viewModels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.identifier, for: indexPath)
        
        if let backdropCell = cell as? MovieBackdropImageView,
           let backdropVM = viewModel as? MovieBackdropImageViewModel {
            backdropCell.configure(viewModel: backdropVM)
        } else if let titleCell = cell as? MovieTitleAndTaglineView,
                  let titleVM = viewModel as? MovieTitleAndTaglineViewModel {
            titleCell.configure(viewModel: titleVM)
        } else if let addToWatchlistCell = cell as? MovieAddToWatchlistAndOverviewView,
                  let addToWatchlistVM = viewModel as? MovieAddToWatchlistAndOverviewViewModel {
            addToWatchlistCell.configure(viewModel: addToWatchlistVM)
        } else if let castListCell = cell as? MovieDetailsCastList,
                  let castListVM = viewModel as? MovieDetailsCastListViewModel {
            castListCell.configure(viewModel: castListVM)
        } else if let subDetailsCell = cell as? MovieSubDetailsView,
                  let subDetailsVM = viewModel as? MovieSubDetailsViewModel {
            subDetailsCell.configure(viewModel: subDetailsVM)
        } else if let productionCell = cell as? MovieDetailsProductionView,
                  let productionVM = viewModel as? MovieDetailsProductionViewModel {
            productionCell.configure(viewModel: productionVM)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = viewModels[indexPath.row]
        let width = collectionView.frame.width
        
        switch viewModel {
        case is MovieSubDetailsViewModel: return CGSize(width: width - 20, height: 30)
        case is MovieBackdropImageViewModel: return CGSize(width: width, height: width * 0.55)
        case is MovieTitleAndTaglineViewModel: return CGSize(width: width - 20, height: 70)
        case is MovieAddToWatchlistAndOverviewViewModel: return CGSize(width: width - 20, height: 120)
        case is MovieDetailsCastListViewModel: return CGSize(width: width - 20, height: 150)
        case is MovieDetailsProductionViewModel: return CGSize(width: width - 20, height: 50)
        default: return CGSize(width: width, height: 100)
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
        
        self.viewModels = [
            MovieBackdropImageViewModel(imagePath: details.backdropPath, size: .w1280),
            MovieTitleAndTaglineViewModel(movieName: details.title, movieTagline: details.tagline),
            
            MovieSubDetailsViewModel(
                year: details.releaseDate, released: CMDateFormatter.isDatePassed(details.releaseDate),
                duration: RuntimeHelper.runtime(details.runtime), imdbPath: details.imdbID,
                didTapIMDB: presenter?.didTapIMDBImage
            ),
            
            MovieAddToWatchlistAndOverviewViewModel(movieOverview: details.overview),
        ]
        
        if let cast = cast, !cast.isEmpty {
            self.viewModels.append(MovieDetailsCastListViewModel(cast: cast, crew: crew))
        }
        
        self.viewModels.append(MovieDetailsProductionViewModel(companies: details.productionCompanies, countries: details.productionCountries))
        
        self.collectionView.reloadData()
    }
}
