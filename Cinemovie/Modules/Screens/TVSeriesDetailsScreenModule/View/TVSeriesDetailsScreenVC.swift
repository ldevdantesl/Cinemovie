//
//  TVSeriesDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit
import SnapKit

protocol TVSeriesDetailsScreenViewProtocol: AnyObject {
    var activeTooltipView: CMTooltipView? { get set }
    var activeTooltipWorkItem: DispatchWorkItem? { get set }
    var activeActorPopUpView: MediaDetailsActorPopupView? { get set }
    
    func didRecieveError(_ errorStr: String)
    func didGetAllTVSeriesData(_ details: TVSeriesDetails, cast: [Cast], videos: [Video])
}

final class TVSeriesDetailsScreenVC: UIViewController {
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let collectionViewSpacing = 10.0
        static let aniDuration = 1.0
        static let hSpacing = 20.0
        static let biggerHSpacing = 30.0
        static let cellDefaultHeight = 100.0
    }

    // MARK: - VIPER
    var presenter: TVSeriesDetailsScreenPresenterProtocol?
    var activeTooltipView: CMTooltipView?
    var activeTooltipWorkItem: DispatchWorkItem?
    var activeActorPopUpView: MediaDetailsActorPopupView?
    
    // MARK: - PROPERTIES
    private var viewModels: [MediaDetailsCellViewModel] = []
    private var cachedCollectionViewCellHeights: [IndexPath : CGSize] = [:]
    private lazy var isFirstScreen = navigationController?.viewControllers.count ?? 0 > 1
    
    // MARK: - VIEW PROPERTIES
    private let downloadingView: CMSplashView = {
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
        cv.register(MediaDetailsRateAndShareView.self, forCellWithReuseIdentifier: MediaDetailsRateAndShareView.identifier)
        cv.register(MediaDetailsProductionView.self, forCellWithReuseIdentifier: MediaDetailsProductionView.identifier)
        cv.register(MediaDetailsBackdropImageView.self, forCellWithReuseIdentifier: MediaDetailsBackdropImageView.identifier)
        cv.register(MediaDetailsTitleView.self, forCellWithReuseIdentifier: MediaDetailsTitleView.identifier)
        cv.register(MediaDetailsCastList.self, forCellWithReuseIdentifier: MediaDetailsCastList.identifier)
        cv.register(MediaDetailsWatchlistOverviewView.self, forCellWithReuseIdentifier: MediaDetailsWatchlistOverviewView.identifier)
        cv.register(TVSeriesDetailsSubDetailsView.self, forCellWithReuseIdentifier: TVSeriesDetailsSubDetailsView.identifier)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadingView.animateLogo()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        view.backgroundColor = CMColor.cmBackground
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

extension TVSeriesDetailsScreenVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = viewModels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.identifier, for: indexPath)
        switch viewModel {
        case let vm as MediaDetailsBackdropImageViewModel: (cell as? MediaDetailsBackdropImageView)?.configure(viewModel: vm)
        case let vm as MediaDetailsTitleViewModel: (cell as? MediaDetailsTitleView)?.configure(viewModel: vm)
        case let vm as MediaDetailsWatchlistOverviewViewModel: (cell as? MediaDetailsWatchlistOverviewView)?.configure(viewModel: vm)
        case let vm as MediaDetailsCastListViewModel: (cell as? MediaDetailsCastList)?.configure(viewModel: vm)
        case let vm as TVSeriesDetailsSubDetailsViewModel: (cell as? TVSeriesDetailsSubDetailsView)?.configure(viewModel: vm)
        case let vm as MediaDetailsProductionViewModel: (cell as? MediaDetailsProductionView)?.configure(viewModel: vm)
        case let vm as MediaDetailsRateAndShareViewModel: (cell as? MediaDetailsRateAndShareView)?.configure(viewModel: vm)
        default: break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let size = cachedCollectionViewCellHeights[indexPath] {
            return size
        }
        
        let viewModel = viewModels[indexPath.row]
        let width = collectionView.frame.width
        
        let size: CGSize
        switch viewModel {
        case let vm as TVSeriesDetailsSubDetailsViewModel: size = CGSize(width: width - Constants.hSpacing, height: vm.cellHeight)
        case let vm as MediaDetailsBackdropImageViewModel: size = CGSize(width: width, height: vm.cellHeight)
        case let vm as MediaDetailsTitleViewModel: size = CGSize(width: width - Constants.hSpacing, height: vm.cellHeight)
        case let vm as MediaDetailsWatchlistOverviewViewModel: size = CGSize(width: width - Constants.hSpacing, height: vm.cellHeight)
        case let vm as MediaDetailsCastListViewModel: size = CGSize(width: width - Constants.hSpacing, height: vm.cellHeight)
        case let vm as MediaDetailsProductionViewModel: size = CGSize(width: width - Constants.hSpacing, height: vm.cellHeight)
        case let vm as MediaDetailsRateAndShareViewModel: size = CGSize(width: width - Constants.biggerHSpacing, height: vm.cellHeight)
        default: return CGSize(width: width, height: Constants.cellDefaultHeight)
        }
        
        cachedCollectionViewCellHeights[indexPath] = size
        return size
    }
}

extension TVSeriesDetailsScreenVC: TVSeriesDetailsScreenViewProtocol {
    func didRecieveError(_ errorStr: String) {
        let alert = UIAlertController(
            title: "Oops..",
            message: errorStr,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            isFirstScreen ? self.dismiss(animated: true) : presenter?.didTapBackButton()
        }
        
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didGetAllTVSeriesData(_ details: TVSeriesDetails, cast: [Cast], videos: [Video]) {
        self.downloadingView.hide()
        
        self.viewModels = [
            MediaDetailsBackdropImageViewModel(
                imagePath: details.backdropPath, size: .w1280,
                isBackButtonHidden: isFirstScreen, didTapBackButtonAction: presenter?.didTapBackButton
            ),
            MediaDetailsTitleViewModel(movieName: details.name, movieTagline: details.tagline),
            
            TVSeriesDetailsSubDetailsViewModel(
                firstAirDate: details.firstAirDate, numberOfSeasons: details.numberOfSeasons ?? 1,
                numberOfEpisodes: details.numberOfEpisodes ?? 1, homepage: details.homepage,
                status: details.status ?? .canceled, nextEpisodeToAir: details.nextEpisodeToAir?.airDate,
                didTapView: presenter?.didTapTooltipView, didTapHomepage: presenter?.didTapHomepage
            ),
            
            MediaDetailsWatchlistOverviewViewModel(movieOverview: details.overview),
        ]
        
        !cast.isEmpty ? self.viewModels.append(MediaDetailsCastListViewModel(cast: cast, didSelectCast: presenter?.didSelectActor)) : ()
        
        self.viewModels.append(MediaDetailsProductionViewModel(companies: details.productionCompanies, countries: details.productionCountries))
        self.viewModels.append(MediaDetailsRateAndShareViewModel(didTapShareButton: presenter?.didTapShareButton, didTapRateButton: presenter?.didTapRateButton))
        
        DispatchQueue.main.async {
            self.collectionView.setNeedsLayout()
            self.collectionView.layoutIfNeeded()
            self.collectionView.reloadData()
            self.collectionView.performBatchUpdates(nil)
        }
    }
}
