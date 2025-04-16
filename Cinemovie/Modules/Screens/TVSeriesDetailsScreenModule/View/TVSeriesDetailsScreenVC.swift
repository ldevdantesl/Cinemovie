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
        crew: [Cast], videos: [Video], reviews: [Review],
        recommends: [TVSeries], similars: [TVSeries]
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
    }
    
    fileprivate enum Items: Hashable {
        case backdropImage(BackdropImageCellViewModel)
        case titleAndTagline(TitleAndTaglineCellViewModel)
        case subDetails(TVSeriesDetailsSubDetailsViewModel)
        case watchListButton
        case overview(OverviewCellViewModel)
        case cast(CastListCellViewModel)
        case production(ProductionInfoCellViewModel)
        case rateAndShare(RateAndShareCellViewModel)
        case mediaExtras(MediaExtrasCellViewModel)
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
    private let downloadingView: CMSplashView = {
        let view = CMSplashView(frame: .zero, showsLoadingLabel: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: DiffableCollectionView = {
        let cv = DiffableCollectionView<Sections, Items>(layout: createLayout())
        cv.backgroundColor = CMColor.cmBackground
        cv.register(cellClass: WatchlistButtonCell.self)
        cv.register(cellClass: OverviewCell.self)
        cv.register(cellClass: RateAndShareCell.self)
        cv.register(cellClass: ProductionInfoCell.self)
        cv.register(cellClass: BackdropImageCell.self)
        cv.register(cellClass: TitleAndTaglineCell.self)
        cv.register(cellClass: CastListCell.self)
        cv.register(cellClass: MediaExtrasCell.self)
        cv.register(cellClass: TVSeriesDetailsSubDetailsView.self)
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
        print("TVSeriesDetails is deinited")
        SDImageCache.shared.clearMemory()
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
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            guard let self = self else {
                let group = NSCollectionLayoutGroup(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                return NSCollectionLayoutSection(group: group)
            }
            let section = self.visibleSections[sectionIndex]
            let heightDimension: NSCollectionLayoutDimension
            var isBackdropImageSection: Bool = false
            
            switch section {
            case .mediaExtras: heightDimension = .estimated(100)
            case .backdropImage: heightDimension = .absolute(BackdropImageCellViewModel.cellHeight); isBackdropImageSection = true
            case .titleAndTagline: heightDimension = .estimated(TitleAndTaglineCellViewModel.estimatedCellHeight)
            case .subDetails: heightDimension = .absolute(MovieDetailsSubDetailsCellViewModel.cellHeight)
            case .watchlistButton: heightDimension = .absolute(WatchlistButtonCellViewModel.absoluteCellHeight)
            case .overview: heightDimension = .estimated(OverviewCellViewModel.estimatedCellHeight)
            case .cast: heightDimension = .absolute(CastListCellViewModel.cellHeight)
            case .production: heightDimension = .absolute(ProductionInfoCellViewModel.cellHeight)
            case .rateAndShare: heightDimension = .absolute(RateAndShareCellViewModel.cellHeight)
            }
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: heightDimension))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: item.layoutSize, subitems: [item])
            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.contentInsets = !isBackdropImageSection ? NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10) : .zero
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
    
    func didGetAllTVSeriesData(
        _ details: TVSeriesDetails, cast: [Cast],
        crew: [Cast], videos: [Video], reviews: [Review],
        recommends: [TVSeries], similars: [TVSeries]
    ) {
        self.downloadingView.hide()
        
        let backdropVM = BackdropImageCellViewModel(
            imagePath: details.backdropPath, size: .w1280,
            isBackButtonHidden: isFirstScreen, didTapBackButtonAction: presenter?.didTapBackButton
        )
        
        let titleVM = TitleAndTaglineCellViewModel(mediaName: details.name, mediaTagline: details.tagline)
        let subDetailsVM = TVSeriesDetailsSubDetailsViewModel(
            firstAirDate: details.firstAirDate, numberOfSeasons: details.numberOfSeasons ?? 0,
            numberOfEpisodes: details.numberOfEpisodes ?? 0, homepage: details.homepage,
            status: details.status ?? .ended, nextEpisodeToAir: details.nextEpisodeToAir?.airDate,
            didTapView: presenter?.didTapTooltipView, didTapHomepage: presenter?.didTapHomepage
        )
        
        var sectionsAndTheirItems: [(section: Sections, items: [Items])] = [
            (.backdropImage, [.backdropImage(backdropVM)]),
            (.titleAndTagline, [.titleAndTagline(titleVM)]),
            (.subDetails, [.subDetails(subDetailsVM)]),
            (.watchlistButton, [.watchListButton])
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
        let extrasVM = MediaExtrasCellViewModel(
            seasons: seasons, similar: similars,
            recommended: recommends, videos: videos, reviews: reviews,
            didTapMedia: presenter?.didTapMedia, didTapSeason: self.presenter?.didSelectSeason
        )
        sectionsAndTheirItems.append((Sections.mediaExtras, [.mediaExtras(extrasVM)]))
        
        self.visibleSections = sectionsAndTheirItems.map { $0.section }
        
        self.collectionView.applySnapshot(
            sections: sectionsAndTheirItems.map { $0.section },
            itemsBySection: Dictionary(uniqueKeysWithValues: sectionsAndTheirItems)
        )
    }
}
