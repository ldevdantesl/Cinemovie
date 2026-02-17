//
//  TVSeriesDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit
import SnapKit
import SDWebImage

protocol TVSeriesDetailsScreenViewProtocol: AnyObject {
    var activeTooltipView: CMTooltipView? { get set }
    var activeTooltipWorkItem: DispatchWorkItem? { get set }
    var activePopUpView: PopUPView? { get set }
    
    func didRecieveError(_ errorStr: String)
    func didGetAllTVSeriesData(
        _ details: TVSeriesDetails, cast: [Cast],
        crew: [Cast], videos: [Video],
        reviews: [Review], recommends: [TVSeries],
        accountStates: MediaAccountStates
    )
}

final class TVSeriesDetailsScreenVC: UIViewController {
    
    // MARK: - OTHER
    fileprivate enum Sections: CaseIterable, Hashable {
        case backdropImage
        case titleAndTagline
        case subDetails
        case watchlistButton
        case overview
        case cast
        case production
        case rateAndShare
        case mediaExtras
        case unavailable
    }
    
    fileprivate enum Items: Hashable {
        case backdropImage(BackdropImageCellViewModel)
        case titleAndTagline(TitleAndTaglineCellViewModel)
        case subDetails(TVSeriesDetailsSubDetailsViewModel)
        case watchListButton(WatchlistButtonCellViewModel)
        case overview(OverviewCellViewModel)
        case cast(CastListCellViewModel)
        case production(ProductionInfoCellViewModel)
        case rateAndShare(RateAndShareCellViewModel)
        case mediaExtras(MediaExtrasCellViewModel)
        case unavailable(UnavailableInfoCellViewModel)
    }

    // MARK: - VIPER
    var presenter: TVSeriesDetailsScreenPresenterProtocol?
    var activeTooltipView: CMTooltipView?
    var activeTooltipWorkItem: DispatchWorkItem?
    var activePopUpView: PopUPView?
    
    // MARK: - PROPERTIES
    private var viewModels: [CellViewModelBaseClass] = []
    private var visibleSections: [Sections] = []
    private lazy var isFirstScreen = navigationController?.viewControllers.count ?? 0 > 1
    
    // MARK: - VIEW PROPERTIES
    private let downloadView: CMSplashView = {
        let view = CMSplashView(frame: .zero, showsLoadingLabel: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: DiffableCollectionView = {
        let cv = DiffableCollectionView<Sections, Items>(layout: createLayout())
        cv.contentInsetAdjustmentBehavior = .never
        cv.backgroundColor = CMColor.cmBackground
        cv.layer.zPosition = 0
        cv.register(cellClass: WatchlistButtonCell.self)
        cv.register(cellClass: OverviewCell.self)
        cv.register(cellClass: RateAndShareCell.self)
        cv.register(cellClass: ProductionInfoCell.self)
        cv.register(cellClass: BackdropImageCell.self)
        cv.register(cellClass: TitleAndTaglineCell.self)
        cv.register(cellClass: CastListCell.self)
        cv.register(cellClass: MediaExtrasCell.self)
        cv.register(cellClass: TVSeriesDetailsSubDetailsView.self)
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupUI()
        configureDataSource()
        downloadView.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SDImageCache.shared.clearMemory()
    }
    
    deinit {
        print("TVSeriesDetails is deinited")
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        view.backgroundColor = CMColor.cmBackground
        view.addSubview(downloadView)
        downloadView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.bringSubviewToFront(downloadView)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            guard let self = self else {
                let group = NSCollectionLayoutGroup(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                return NSCollectionLayoutSection(group: group)
            }
            let section = self.visibleSections[sectionIndex]
            let edgeInsets: NSDirectionalEdgeInsets
            switch section {
            case .backdropImage: edgeInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0)
            case .titleAndTagline: edgeInsets =  NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
            default: edgeInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
            }
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: item.layoutSize, subitems: [item])
            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.contentInsets = edgeInsets
            return layoutSection
        }
    }
    
    private func configureDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .mediaExtras(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? MediaExtrasCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .backdropImage(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? BackdropImageCell
                cell?.configure(with: vm)
                return cell
                
            case .subDetails(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? TVSeriesDetailsSubDetailsView
                cell?.configure(viewModel: vm)
                return cell
                
            case .watchListButton(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? WatchlistButtonCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .cast(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? CastListCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .titleAndTagline(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? TitleAndTaglineCell
                cell?.layer.zPosition = 1
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
                
            case .unavailable(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? UnavailableInfoCell
                cell?.configure(viewModel: vm)
                return cell
            }
        }
    }
}

extension TVSeriesDetailsScreenVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? BackdropImageCell else { return }
        let offsetY = scrollView.contentOffset.y
        offsetY <= 0 ? cell.scaleImage(to: offsetY) : cell.resetScale()
    }
}

extension TVSeriesDetailsScreenVC: TVSeriesDetailsScreenViewProtocol {
    // MARK: - ERROR HANDLING
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
    
    // MARK: - DATA RECIEVING
    func didGetAllTVSeriesData(
        _ details: TVSeriesDetails, cast: [Cast],
        crew: [Cast], videos: [Video],
        reviews: [Review], recommends: [TVSeries],
        accountStates: MediaAccountStates
    ) {
        self.downloadView.hide()
        
        let backdropVM = BackdropImageCellViewModel(
            imagePath: details.backdropPath,
            size: .w1280, isFavorite: accountStates.favorite,
            didTapBackButtonAction: presenter?.didTapBackButton,
            didTapFavorite: presenter?.didTapFavoriteButton
        )
        
        let titleVM = TitleAndTaglineCellViewModel(mediaName: details.name, mediaTagline: details.tagline)
        let subDetailsVM = TVSeriesDetailsSubDetailsViewModel(
            firstAirDate: details.firstAirDate, numberOfSeasons: details.numberOfSeasons ?? 0,
            numberOfEpisodes: details.numberOfEpisodes ?? 0, homepage: details.homepage,
            status: details.status ?? .ended, nextEpisodeToAir: details.nextEpisodeToAir?.airDate,
            didTapView: presenter?.didTapTooltipView, didTapHomepage: presenter?.didTapHomepage
        )
        
        let watchlistVm = WatchlistButtonCellViewModel(
            isWatchlisted: accountStates.watchlist,
            showsAddToListButton: (presenter?.userLists.count ?? 0) > 0,
            didTapAction: presenter?.didTapWatchlistButton,
            didTapAddToList: presenter?.didTapAddToList
        )
        
        var sectionsAndTheirItems: [(section: Sections, items: [Items])] = [
            (.backdropImage, [.backdropImage(backdropVM)]),
            (.titleAndTagline, [.titleAndTagline(titleVM)]),
            (.subDetails, [.subDetails(subDetailsVM)]),
            (.watchlistButton, [.watchListButton(watchlistVm)])
        ]
        
        if !details.overview.isEmpty {
            let overviewVM = OverviewCellViewModel(overviewText: details.overview)
            sectionsAndTheirItems.append((Sections.overview, [.overview(overviewVM)]))
        }
        
        if !cast.isEmpty || !crew.isEmpty {
            let castVM = CastListCellViewModel(cast: !cast.isEmpty ? cast : crew, didSelectCast: presenter?.didSelectActor)
            sectionsAndTheirItems.append((Sections.cast, [.cast(castVM)]))
        }
        
        let prodVM = ProductionInfoCellViewModel(companies: details.productionCompanies, countries: details.productionCountries)
        sectionsAndTheirItems.append((Sections.production, [.production(prodVM)]))
        
        let rateVM = RateAndShareCellViewModel(didTapShareButton: presenter?.didTapShareButton, didTapRateButton: presenter?.didTapRateButton)
        sectionsAndTheirItems.append((Sections.rateAndShare, [.rateAndShare(rateVM)]))
        
        let seasons = details.seasons.filter { $0.seasonNumber != 0 }
        if !seasons.isEmpty || !recommends.isEmpty || !videos.isEmpty || !reviews.isEmpty {
            let extrasVM = MediaExtrasCellViewModel(
                seasons: seasons, recommended: recommends, videos: videos, reviews: reviews,
                didTapMedia: presenter?.didTapMedia, didTapSeason: presenter?.didSelectSeason
            )
            sectionsAndTheirItems.append((Sections.mediaExtras, [.mediaExtras(extrasVM)]))
        } else {
            let unavailableVM = UnavailableInfoCellViewModel(
                title: "No additional content available",
                subtitle: "We couldn’t find any related seasons, videos, reviews, or recommendations for this TV Series.",
                image: UIImage(named: ImageNames.empty2.rawValue)
            )
            sectionsAndTheirItems.append((Sections.unavailable, [.unavailable(unavailableVM)]))
        }
        
        self.visibleSections = sectionsAndTheirItems.map { $0.section }
        
        self.collectionView.applySnapshot(
            sections: sectionsAndTheirItems.map { $0.section },
            itemsBySection: Dictionary(uniqueKeysWithValues: sectionsAndTheirItems)
        )
    }
}
