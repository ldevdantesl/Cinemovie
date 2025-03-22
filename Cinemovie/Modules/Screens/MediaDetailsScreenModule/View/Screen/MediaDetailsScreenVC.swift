//
//  MovieDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

import UIKit
import SnapKit
import SDWebImage

protocol MediaDetailsScreenViewProtocol: AnyObject {
    func didRecieveError(_ errorStr: String)
    func didDownloadAllData(
        details: MovieDetails, videos: [DomainVideo]?,
        cast: [Cast]?, crew: [Cast]?,
        recommends: [QueryMovie]?, reviews: [DomainReview]?,
        reviewCount: Int?
    )
}

final class MediaDetailsScreenVC: UIViewController {
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let collectionViewSpacing = 10.0
        static let aniDuration = 1.0
        static let hSpacing = 20.0
        static let biggerHSpacing = 30.0
        static let cellDefaultHeight = 120.0
    }
    
    // MARK: - VIPER
    var presenter: MediaDetailsScreenPresenterProtocol?
    
    // MARK: - PROPERTIES
    private var viewModels: [MovieDetailsCellViewModel] = []
    
    // MARK: - VIEW PROPERTIES
    private lazy var downloadingView: CMSplashView = {
        let view = CMSplashView(frame: .zero, showsLoadingLabel: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.collectionViewSpacing
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = CMColor.cmBackground
        cv.register(MovieDetailsRateAndShareView.self, forCellWithReuseIdentifier: MovieDetailsRateAndShareView.identifier)
        cv.register(MovieDetailsProductionView.self, forCellWithReuseIdentifier: MovieDetailsProductionView.identifier)
        cv.register(MovieDetailsSubDetailsView.self, forCellWithReuseIdentifier: MovieDetailsSubDetailsView.identifier)
        cv.register(MovieDetailsBackdropImageView.self, forCellWithReuseIdentifier: MovieDetailsBackdropImageView.identifier)
        cv.register(MovieDetailsTitleView.self, forCellWithReuseIdentifier: MovieDetailsTitleView.identifier)
        cv.register(MovieDetailsCastList.self, forCellWithReuseIdentifier: MovieDetailsCastList.identifier)
        cv.register(MovieDetailsWatchlistOverviewView.self, forCellWithReuseIdentifier: MovieDetailsWatchlistOverviewView.identifier)
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
    
    private func dynamicHeightForCell(viewModel: MovieDetailsCellViewModel, width: CGFloat) -> CGSize {
        if let overviewVM = viewModel as? MovieDetailsWatchlistOverviewViewModel {
            return CGSize(width: width - Constants.hSpacing, height: overviewVM.cellHeight)
        }
        
        return CGSize(width: width - Constants.hSpacing, height: Constants.cellDefaultHeight)
    }
}

extension MediaDetailsScreenVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = viewModels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.identifier, for: indexPath)

        switch viewModel {
        case let vm as MovieDetailsBackdropImageViewModel: (cell as? MovieDetailsBackdropImageView)?.configure(viewModel: vm)
        case let vm as MovieDetailsTitleViewModel: (cell as? MovieDetailsTitleView)?.configure(viewModel: vm)
        case let vm as MovieDetailsWatchlistOverviewViewModel:
            (cell as? MovieDetailsWatchlistOverviewView)?.configure(viewModel: vm)
            collectionView.collectionViewLayout.invalidateLayout()
        case let vm as MovieDetailsCastListViewModel: (cell as? MovieDetailsCastList)?.configure(viewModel: vm)
        case let vm as MovieDetailsSubDetailsViewModel: (cell as? MovieDetailsSubDetailsView)?.configure(viewModel: vm)
        case let vm as MovieDetailsProductionViewModel: (cell as? MovieDetailsProductionView)?.configure(viewModel: vm)
        case let vm as MovieDetailsRateAndShareViewModel: (cell as? MovieDetailsRateAndShareView)?.configure(viewModel: vm)
        default: break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = viewModels[indexPath.row]
        let width = collectionView.frame.width
        
        switch viewModel {
        case is MovieDetailsSubDetailsViewModel: return CGSize(width: width - Constants.hSpacing, height: 25)
        case is MovieDetailsBackdropImageViewModel: return CGSize(width: width, height: width * 0.55)
        case let vm as MovieDetailsTitleViewModel: return CGSize(width: width - Constants.hSpacing, height: vm.isTaglineAvailable ? 70 : 55)
        case is MovieDetailsWatchlistOverviewViewModel: return dynamicHeightForCell(viewModel: viewModel, width: width)
        case is MovieDetailsCastListViewModel: return CGSize(width: width - Constants.hSpacing, height: 150)
        case is MovieDetailsProductionViewModel: return CGSize(width: width - Constants.hSpacing, height: 50)
        case is MovieDetailsRateAndShareViewModel: return CGSize(width: width - Constants.biggerHSpacing, height: 40)
        default: return CGSize(width: width, height: Constants.cellDefaultHeight)
        }
    }
}

extension MediaDetailsScreenVC: MediaDetailsScreenViewProtocol {
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
        self.present(alert, animated: true, completion: nil)
    }
    
    func didDownloadAllData(
        details: MovieDetails, videos: [DomainVideo]?,
        cast: [Cast]?, crew: [Cast]?,
        recommends: [QueryMovie]?, reviews: [DomainReview]?,
        reviewCount: Int?
    ) {
        UIView.animate(withDuration: Constants.aniDuration, delay: Constants.aniDuration, options: .showHideTransitionViews) { [weak self] in
            guard let self = self else { return }
            self.downloadingView.alpha = 0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.downloadingView.isHidden = true
        }
        
        self.viewModels = [
            MovieDetailsBackdropImageViewModel(imagePath: details.backdropPath, size: .w1280),
            MovieDetailsTitleViewModel(movieName: details.title, movieTagline: details.tagline),
            
            MovieDetailsSubDetailsViewModel(
                year: details.releaseDate, released: CMDateFormatter.isDatePassed(details.releaseDate),
                duration: RuntimeHelper.runtime(details.runtime), imdbPath: details.imdbID,
                didTapIMDB: presenter?.didTapIMDBImage
            ),
            
            MovieDetailsWatchlistOverviewViewModel(movieOverview: details.overview),
        ]
        
        if let cast = cast, !cast.isEmpty {
            self.viewModels.append(MovieDetailsCastListViewModel(cast: cast, didSelectCast: presenter?.didSelectActor))
        }
        
        self.viewModels.append(MovieDetailsProductionViewModel(companies: details.productionCompanies, countries: details.productionCountries))
        self.viewModels.append(MovieDetailsRateAndShareViewModel(didTapShareButton: presenter?.didTapShareButton, didTapRateButton: presenter?.didTapRateButton))
        
        self.collectionView.reloadData()
    }
}
