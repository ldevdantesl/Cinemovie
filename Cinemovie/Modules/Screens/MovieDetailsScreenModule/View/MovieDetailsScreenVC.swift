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
    var activePopUpView: ActorPopupView? { get set }

    func didRecieveError(_ errorStr: String)
    func didDownloadAllData(
        details: MovieDetails, videos: [Video],
        cast: [Cast], crew: [Cast],
        similar: [Movie], recommended: [Movie], reviews: [Review],
        belongsToCollectionDetails: BelongsToCollectionDetails?
    )
}

final class MovieDetailsScreenVC: UIViewController {
    
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
        case subDetails(MovieDetailsSubDetailsCellViewModel)
        case watchListButton
        case overview(OverviewCellViewModel)
        case cast(CastListCellViewModel)
        case production(ProductionInfoCellViewModel)
        case rateAndShare(RateAndShareCellViewModel)
        case mediaExtras(MediaExtrasCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: MovieDetailsScreenPresenterProtocol?
    var activeTooltipView: CMTooltipView?
    var activeTooltipWorkItem: DispatchWorkItem?
    var activePopUpView: ActorPopupView?
    
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
        let cv = DiffableCollectionView<Sections, Items>(layout: createLayout(), showsTopBlur: true)
        cv.backgroundColor = CMColor.cmBackground
        cv.register(cellClass: MovieDetailsSubDetailsCell.self)
        cv.register(cellClass: WatchlistButtonCell.self)
        cv.register(cellClass: OverviewCell.self)
        cv.register(cellClass: RateAndShareCell.self)
        cv.register(cellClass: ProductionInfoCell.self)
        cv.register(cellClass: BackdropImageCell.self)
        cv.register(cellClass: TitleAndTaglineCell.self)
        cv.register(cellClass: CastListCell.self)
        cv.register(cellClass: MediaExtrasCell.self)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var lastContentOffsetY: CGFloat = 0
    
    private let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        navigationController?.navigationBar.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadingView.show()
    }
    
    deinit {
        print("MovieDetails is deinited")
        SDImageCache.shared.clearMemory()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        view.backgroundColor = CMColor.cmBackground
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(downloadingView)
        downloadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(UIConstants.topInset)
        }
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
        details: MovieDetails, videos: [Video],
        cast: [Cast], crew: [Cast],
        similar: [Movie], recommended: [Movie], reviews: [Review],
        belongsToCollectionDetails: BelongsToCollectionDetails?
    ) {
        self.downloadingView.hide()
        let backdropVM = BackdropImageCellViewModel(
            imagePath: details.backdropPath, size: .w1280,
            isBackButtonHidden: isFirstScreen, didTapBackButtonAction: presenter?.didTapBackButton
        )
        
        let titleVM = TitleAndTaglineCellViewModel(mediaName: details.title, mediaTagline: details.tagline)
        let subDetailsVM = MovieDetailsSubDetailsCellViewModel(
            year: details.releaseDate, released: CMDateFormatter.isDatePassed(details.releaseDate),
            duration: RuntimeHelper.runtime(details.runtime), imdbPath: details.imdbID,
            didTapIMDB: presenter?.didTapIMDBImage, didTapSubDetails: presenter?.didTapToSubDetails
        )
        
        var sectionsAndTheirItems: [(sections: (Sections), items: [Items])] = [
            (Sections.backdropImage, [.backdropImage(backdropVM)]),
            (Sections.titleAndTagline, [.titleAndTagline(titleVM)]),
            (Sections.subDetails, [.subDetails(subDetailsVM)]),
            (Sections.watchlistButton, [.watchListButton])
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
        
        let extrasVM = MediaExtrasCellViewModel(
            collectionDetails: belongsToCollectionDetails, similar: similar,
            recommended: recommended, videos: videos,
            reviews: reviews, didTapMedia: presenter?.didTapMedia
        )
        
        sectionsAndTheirItems.append((Sections.mediaExtras, [.mediaExtras(extrasVM)]))
        
        self.visibleSections = sectionsAndTheirItems.map { $0.sections }
        
        self.collectionView.applySnapshot(
            sections: visibleSections,
            itemsBySection: Dictionary(uniqueKeysWithValues: sectionsAndTheirItems)
        )
    }
}
