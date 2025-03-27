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
    var activeTooltipView: CMTooltipView? { get set }
    var activeTooltipWorkItem: DispatchWorkItem? { get set }
    
    var activePopUpView: MediaDetailsActorPopupView? { get set }

    func didRecieveError(_ errorStr: String)
    func didDownloadAllData(
        details: MovieDetails, videos: [Video]?,
        cast: [Cast], crew: [Cast],
        recommends: [Movie]?, reviews: [Review]?,
        reviewCount: Int?
    )
}

final class MovieDetailsScreenVC: UIViewController {
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let collectionViewSpacing = 10.0
        static let aniDuration = 1.0
        static let hSpacing = 20.0
        static let biggerHSpacing = 30.0
        static let cellDefaultHeight = 120.0
    }
    
    private enum MovieDetailsSection: CaseIterable, Hashable {
        case backdropImage
        case titleAndTagline
        case subDetails
        case watchlistButton
        case overview
        case cast
        case production
        case rateAndShare
    }
    
    private enum MovieDetailsItems: Hashable {
        case backdropImage(BackdropImageCellViewModel)
        case titleAndTagline(TitleAndTaglineCellViewModel)
        case subDetails(MovieDetailsSubDetailsCellViewModel)
        case watchListButton
        case overview(OverviewCellViewModel)
        case cast(CastListCellViewModel)
        case production(ProductionInfoCellViewModel)
        case rateAndShare(RateAndShareCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: MovieDetailsScreenPresenterProtocol?
    var activeTooltipView: CMTooltipView?
    var activeTooltipWorkItem: DispatchWorkItem?
    var activePopUpView: MediaDetailsActorPopupView?
    
    // MARK: - PROPERTIES
    private var viewModels: [CellViewModel] = []
    private lazy var isFirstScreen = navigationController?.viewControllers.count ?? 0 > 1
    
    // MARK: - VIEW PROPERTIES
    private let downloadingView: CMSplashView = {
        let view = CMSplashView(frame: .zero, showsLoadingLabel: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: CMCollectionView = {
        let cv = CMCollectionView<MovieDetailsSection, MovieDetailsItems>(layout: createLayout())
        cv.backgroundColor = CMColor.cmBackground
        cv.register(cellClass: MovieDetailsSubDetailsCell.self)
        cv.register(cellClass: WatchlistButtonCell.self)
        cv.register(cellClass: OverviewCell.self)
        cv.register(cellClass: RateAndShareCell.self)
        cv.register(cellClass: ProductionInfoCell.self)
        cv.register(cellClass: BackdropImageCell.self)
        cv.register(cellClass: TitleAndTaglineCell.self)
        cv.register(cellClass: CastListCell.self)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupUI()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadingView.animateLogo()
    }
    
    deinit {
        print("MovieDetails is deinited")
        SDImageCache.shared.clearMemory()
    }
    
    // MARK: - PRIVATE FUNCTIONS
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
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            let section = MovieDetailsSection.allCases[sectionIndex]
            let heightDimension: NSCollectionLayoutDimension
            var itemHeightDimension: NSCollectionLayoutDimension = .fractionalHeight(1)
            var isBackdropImageSection: Bool = false
            
            switch section {
            case .backdropImage: heightDimension = .absolute(BackdropImageCellViewModel.cellHeight); isBackdropImageSection = true
            case .titleAndTagline: heightDimension = .estimated(TitleAndTaglineCellViewModel.estimatedCellHeight); itemHeightDimension = .estimated(50)
            case .subDetails: heightDimension = .absolute(MovieDetailsSubDetailsCellViewModel.cellHeight)
            case .watchlistButton: heightDimension = .absolute(WatchlistButtonCellViewModel.absoluteCellHeight)
            case .overview: heightDimension = .estimated(OverviewCellViewModel.estimatedCellHeight); itemHeightDimension = .estimated(OverviewCellViewModel.estimatedCellHeight)
            case .cast: heightDimension = .absolute(CastListCellViewModel.cellHeight)
            case .production: heightDimension = .absolute(ProductionInfoCellViewModel.cellHeight)
            case .rateAndShare: heightDimension = .absolute(RateAndShareCellViewModel.cellHeight)
            }
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: itemHeightDimension))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: heightDimension), subitems: [item])
            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.contentInsets = !isBackdropImageSection ? NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10) : .zero
            return layoutSection
        }
    }
    
    private func configureDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .backdropImage(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? BackdropImageCell
                cell?.configure(with: vm)
                return cell
                
            case .subDetails(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? MovieDetailsSubDetailsCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .watchListButton:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WatchlistButtonCell.identifier, for: indexPath) as? WatchlistButtonCell
                return cell
                
            case .cast(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? CastListCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .titleAndTagline(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? TitleAndTaglineCell
                cell?.configure(with: vm)
                return cell
                
            case .overview(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? OverviewCell
                cell?.configure(with: vm)
                return cell
                
            case .production(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? ProductionInfoCell
                cell?.configure(with: vm)
                return cell
                
            case .rateAndShare(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? RateAndShareCell
                cell?.configure(with: vm)
                return cell
            }
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

        let action = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            isFirstScreen ? self.dismiss(animated: true) : presenter?.didTapBackButton()
        }

        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didDownloadAllData(
        details: MovieDetails, videos: [Video]?,
        cast: [Cast], crew: [Cast],
        recommends: [Movie]?, reviews: [Review]?,
        reviewCount: Int?
    ) {
        self.downloadingView.hide()
        let backdropVM = BackdropImageCellViewModel(
            imagePath: details.backdropPath, size: .w1280,
            isBackButtonHidden: isFirstScreen, didTapBackButtonAction: presenter?.didTapBackButton
        )
        
        let titleVM = TitleAndTaglineCellViewModel(movieName: details.title, movieTagline: details.tagline)
        let subDetailsVM = MovieDetailsSubDetailsCellViewModel(
            year: details.releaseDate, released: CMDateFormatter.isDatePassed(details.releaseDate),
            duration: RuntimeHelper.runtime(details.runtime), imdbPath: details.imdbID,
            didTapIMDB: presenter?.didTapIMDBImage, didTapSubDetails: presenter?.didTapToSubDetails
        )
        
        let overviewVM = OverviewCellViewModel(overviewText: details.overview)
        
        let castVM = CastListCellViewModel(cast: cast, didSelectCast: presenter?.didSelectActor)
        let prodVM = ProductionInfoCellViewModel(companies: details.productionCompanies, countries: details.productionCountries)
        let rateVM = RateAndShareCellViewModel(didTapShareButton: presenter?.didTapShareButton, didTapRateButton: presenter?.didTapRateButton)
        
        self.collectionView.applySnapshot(
            sections: [.backdropImage, .titleAndTagline, .subDetails, .watchlistButton, .overview, .cast, .production, .rateAndShare],
            itemsBySection: [
                .backdropImage : [.backdropImage(backdropVM)],
                .titleAndTagline : [.titleAndTagline(titleVM)],
                .subDetails: [.subDetails(subDetailsVM)],
                .watchlistButton: [.watchListButton],
                .overview : [.overview(overviewVM)],
                .cast : [.cast(castVM)],
                .production : [.production(prodVM)],
                .rateAndShare : [.rateAndShare(rateVM)]
            ]
        )
    }
}
