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
        recommended: [Movie], reviews: [Review],
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
        case unavailable
    }
    
    fileprivate enum Items: Hashable {
        case backdropImage(BackdropImageCellViewModel)
        case titleAndTagline(TitleAndTaglineCellViewModel)
        case subDetails(MovieDetailsSubDetailsCellViewModel)
        case watchListButton(LongButtonCellViewModel)
        case overview(OverviewCellViewModel)
        case cast(CastListCellViewModel)
        case production(ProductionInfoCellViewModel)
        case rateAndShare(RateAndShareCellViewModel)
        case mediaExtras(MediaExtrasCellViewModel)
        case unavailable(UnavailableInfoCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: MovieDetailsScreenPresenterProtocol?
    var activeTooltipView: CMTooltipView?
    var activeTooltipWorkItem: DispatchWorkItem?
    var activePopUpView: ActorPopupView?
    
    // MARK: - PROPERTIES
    private var viewModels: [CellViewModelBaseClass] = []
    private var visibleSections: [Sections] = []
    
    // MARK: - VIEW PROPERTIES
    private let downloadingView: CMSplashView = {
        let view = CMSplashView(frame: .zero, showsLoadingLabel: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: DiffableCollectionView = {
        let cv = DiffableCollectionView<Sections, Items>(layout: createLayout(), showsTopBlur: true)
        cv.backgroundColor = CMColor.cmBackground
        cv.layer.zPosition = 0
        cv.register(cellClass: MovieDetailsSubDetailsCell.self)
        cv.register(cellClass: LongButtonCell.self)
        cv.register(cellClass: OverviewCell.self)
        cv.register(cellClass: RateAndShareCell.self)
        cv.register(cellClass: ProductionInfoCell.self)
        cv.register(cellClass: BackdropImageCell.self)
        cv.register(cellClass: TitleAndTaglineCell.self)
        cv.register(cellClass: CastListCell.self)
        cv.register(cellClass: UnavailableInfoCell.self)
        cv.register(cellClass: MediaExtrasCell.self)
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
        downloadingView.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.alpha = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SDImageCache.shared.clearMemory()
    }
    
    deinit {
        print("MovieDetails is deinited")
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
                cell?.layer.zPosition = -1
                cell?.configure(with: vm)
                return cell
                
            case .subDetails(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? MovieDetailsSubDetailsCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .watchListButton(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? LongButtonCell
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

extension MovieDetailsScreenVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.showBlur(scrollView)
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? BackdropImageCell else { return }
        let offsetY = scrollView.contentOffset.y
        offsetY <= 0 ? cell.scaleImage(to: offsetY) : cell.resetScale()
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
            presenter?.didTapBackButton()
        }

        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didDownloadAllData(
        details: MovieDetails, videos: [Video],
        cast: [Cast], crew: [Cast],
        recommended: [Movie], reviews: [Review],
        belongsToCollectionDetails: BelongsToCollectionDetails?
    ) {
        self.downloadingView.hide()
        let backdropVM = BackdropImageCellViewModel(
            imagePath: details.backdropPath, size: .w1280,
            didTapBackButtonAction: presenter?.didTapBackButton
        )
        
        let titleVM = TitleAndTaglineCellViewModel(mediaName: details.title, mediaTagline: details.tagline)
        let subDetailsVM = MovieDetailsSubDetailsCellViewModel(
            year: details.releaseDate, released: CMDateFormatter.isDatePassed(details.releaseDate),
            duration: RuntimeHelper.runtime(details.runtime), imdbPath: details.imdbID,
            didTapIMDB: presenter?.didTapIMDBImage, didTapSubDetails: presenter?.didTapToSubDetails
        )
        
        let longButtonVM = LongButtonCellViewModel(text: "Watchlist", imageSystemName: "plus", action: presenter?.didTapAddToWatchlist)
        
        var sectionsAndTheirItems: [(sections: (Sections), items: [Items])] = [
            (Sections.backdropImage, [.backdropImage(backdropVM)]),
            (Sections.titleAndTagline, [.titleAndTagline(titleVM)]),
            (Sections.subDetails, [.subDetails(subDetailsVM)]),
            (Sections.watchlistButton, [.watchListButton(longButtonVM)])
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
        
        if belongsToCollectionDetails != nil || !recommended.isEmpty || !videos.isEmpty || !reviews.isEmpty {
            let extrasVM = MediaExtrasCellViewModel(
                collectionDetails: belongsToCollectionDetails,
                recommended: recommended, videos: videos,
                reviews: reviews, didTapMedia: presenter?.didTapMedia
            )
            sectionsAndTheirItems.append((Sections.mediaExtras, [.mediaExtras(extrasVM)]))
        } else {
            let unavailableVM = UnavailableInfoCellViewModel(
                title: "No additional content available",
                subtitle: "We couldn’t find any related videos, reviews, or recommendations for this movie.",
                image: UIImage(named: ImageNames.empty2.rawValue)
            )
            sectionsAndTheirItems.append((Sections.unavailable, [.unavailable(unavailableVM)]))
        }
        
        self.visibleSections = sectionsAndTheirItems.map { $0.sections }
        
        self.collectionView.applySnapshot(
            sections: visibleSections,
            itemsBySection: Dictionary(uniqueKeysWithValues: sectionsAndTheirItems)
        )
    }
}
