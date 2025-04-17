//
//  HomeScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import SnapKit
import UIKit

protocol HomeScreenViewProtocol: AnyObject {
    func didRecieveAllMovies(popularMovies: [Movie], upcomingMovies: [Movie], topRatedMovies: [Movie], nowPlayingMovies: [Movie], allMovies: [Movie])
    //func didRecieveAllTVSeries(popularTVSeries: [TVSeries], topRatedTVSeries: [TVSeries], onTheAirTVSeries: [TVSeries], airingTodayTVSeries: [TVSeries], allTVSeries: [TVSeries])
    func didRecieveError(_ errorStr: String)
}

final class HomeScreenVC: UIViewController {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let featuredMovieHeight = UIConstants.screenHeight * 0.55
        static let headerViewHeight = 75.0 + UIConstants.topInset
    }
    
    // MARK: - OTHER
    private enum Section: Int, CaseIterable {
        case featured
        case popularMoviesList
        case upcomingMoviesList
        case topRatedMoviesList
        case nowPlayingMoviesList
        case popularTVSeriesList
        case airingTodayTVSeriesList
        case topRatedTVSeriesList
        case onTheAirTVSeriesList
        
        var title: String {
            switch self {
            case .popularMoviesList: "Popular Movies"
            case .upcomingMoviesList: "Upcoming Movies"
            case .topRatedMoviesList: "Top Rated Movies"
            case .nowPlayingMoviesList: "Now Playing Movies"
            case .popularTVSeriesList: "Popular TV Series"
            case .airingTodayTVSeriesList: "Airing Today Series"
            case .topRatedTVSeriesList: "Top Rated Series"
            case .onTheAirTVSeriesList: "On the Air Series"
            default: ""
            }
        }
        
        var subtitle: String? {
            switch self {
            case .popularMoviesList: "Popular Movies in your area"
            case .upcomingMoviesList: "Movies coming soon"
            case .topRatedMoviesList: "Worldwide top rated movies"
            case .nowPlayingMoviesList: "Now playing movies"
            case .popularTVSeriesList: "Popular Series in your area"
            case .airingTodayTVSeriesList: "Series coming today"
            case .topRatedTVSeriesList: "Worldwide top rated Series"
            case .onTheAirTVSeriesList: "Series currently broadcasting new episodes"
            default: nil
            }
        }
    }

    private enum Item: Hashable {
        case featured(FeaturedMediaCellViewModel)
        case mediaListCell(MediaListCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: HomeScreenPresenterProtocol?
    
    // MARK: - PROPERTIES
    private var viewModels: [CellViewModelBaseClass] = []
    private var headerViewHeightConstraint: Constraint?
    private var isBlurToHeaderVisible: Bool = false
    private var visibleItems: [Section] = []
    
    // MARK: - VIEW PROPERTIES
    private lazy var collectionView: DiffableCollectionView = {
        let view = DiffableCollectionView<Section, Item>(layout: createLayout())
        view.register(cellClass: FeaturedMediaCell.self)
        view.register(cellClass: MediaListCell.self)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = CMColor.cmBackground
        return view
    }()
    
    private lazy var headerView: HomeScreenHeaderView = {
        let vm = HomeScreenHeaderViewModel(headerTitle: "Discover", didTapSearchButton: nil, didTapMoviesButton: switchToTVShows, didTapTVSeriesButton:switchToMovies)
        let view = HomeScreenHeaderView(viewModel: vm)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoaded()
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.barTintColor = CMColor.cmBackground
        tabBarController?.tabBar.isTranslucent = false
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constants.headerViewHeight)
        }
    }
    
    private func configureDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, homeItem in
            switch homeItem {
            case .featured(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? FeaturedMediaCell
                cell?.configure(with: vm)
                return cell
                
            case .mediaListCell(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? MediaListCell
                cell?.configure(viewModel: vm)
                return cell
            }
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            guard let self = self else {
                return NSCollectionLayoutSection(group: .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))))
            }
            let section = self.visibleItems[sectionIndex]
            
            switch section {
            case .featured: return self.sectionForFeatured()
            default: return self.sectionForMovieLists()
            }
        }
    }
    
    private func sectionForFeatured() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Constants.featuredMovieHeight)),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: Constants.headerViewHeight - UIConstants.topInset, leading: 10, bottom: 10, trailing: 10)
        return section
    }
    
    private func sectionForMovieLists() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(MediaListCellViewModel.cellHeight)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: item.layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return section
    }
    
    private func switchToTVShows() {
        guard let presenter = presenter else { return }
        var sectionsAndTheirItems: [(section: Section, items: [Item])] = []
        
        if !presenter.allTVSeries.isEmpty {
            let featuredVM = FeaturedMediaCellViewModel(media: presenter.allTVSeries, didTapMedia: self.presenter?.didTapMedia)
            sectionsAndTheirItems.append((Section.featured, [.featured(featuredVM)]))
        }
        
        if !presenter.popularTVSeries.isEmpty {
            let popularListVM = MediaListCellViewModel(
                mediaItems: presenter.popularTVSeries, listName: Section.popularTVSeriesList.title,
                listSubtitle: Section.popularTVSeriesList.subtitle, didTapMediaItem: presenter.didTapMedia
            )
            sectionsAndTheirItems.append((Section.popularTVSeriesList, [.mediaListCell(popularListVM)]))
        }
        
        if !presenter.airingTodayTVSeries.isEmpty {
            let airingTodayListVM = MediaListCellViewModel(
                mediaItems: presenter.airingTodayTVSeries, listName: Section.airingTodayTVSeriesList.title,
                listSubtitle: Section.airingTodayTVSeriesList.subtitle, didTapMediaItem: presenter.didTapMedia
            )
            sectionsAndTheirItems.append((Section.airingTodayTVSeriesList, [.mediaListCell(airingTodayListVM)]))
        }
        
        if !presenter.topRatedTVSeries.isEmpty {
            let topListVM = MediaListCellViewModel(
                mediaItems: presenter.topRatedTVSeries, listName: Section.topRatedTVSeriesList.title,
                listSubtitle: Section.topRatedTVSeriesList.subtitle, didTapMediaItem: presenter.didTapMedia
            )
            sectionsAndTheirItems.append((Section.topRatedTVSeriesList, [.mediaListCell(topListVM)]))
        }
        
        if !presenter.onTheAirTVSeries.isEmpty {
            let onTheAirListVM = MediaListCellViewModel(
                mediaItems: presenter.onTheAirTVSeries, listName: Section.onTheAirTVSeriesList.title,
                listSubtitle: Section.onTheAirTVSeriesList.subtitle, didTapMediaItem: presenter.didTapMedia
            )
            sectionsAndTheirItems.append((Section.onTheAirTVSeriesList, [.mediaListCell(onTheAirListVM)]))
        }
        
        self.visibleItems = sectionsAndTheirItems.map { $0.section }
        
        DispatchQueue.main.async {
            self.collectionView.applySnapshot(
                sections: self.visibleItems,
                itemsBySection: Dictionary(uniqueKeysWithValues: sectionsAndTheirItems)
            )
        }
    }
    
    private func switchToMovies() {
        guard let presenter = presenter else { return }
        var sectionsAndTheirItems: [(section: Section, items: [Item])] = []
        
        if !presenter.allMovies.isEmpty {
            let featuredVM = FeaturedMediaCellViewModel(media: presenter.allMovies, didTapMedia: presenter.didTapMedia)
            sectionsAndTheirItems.append((Section.featured, [.featured(featuredVM)]))
        }
        
        if !presenter.popularMovies.isEmpty {
            let popularListVM = MediaListCellViewModel(
                mediaItems: presenter.popularMovies, listName: Section.popularMoviesList.title,
                listSubtitle: Section.popularMoviesList.subtitle, didTapMediaItem: presenter.didTapMedia
            )
            sectionsAndTheirItems.append((Section.popularMoviesList, [.mediaListCell(popularListVM)]))
        }
        
        if !presenter.upcomingMovies.isEmpty {
            let upcomingListVM = MediaListCellViewModel(
                mediaItems: presenter.upcomingMovies, listName: Section.upcomingMoviesList.title,
                listSubtitle: Section.upcomingMoviesList.subtitle, didTapMediaItem: presenter.didTapMedia
            )
            sectionsAndTheirItems.append((Section.upcomingMoviesList, [.mediaListCell(upcomingListVM)]))
        }
        
        if !presenter.topRatedMovies.isEmpty {
            let topListVM = MediaListCellViewModel(
                mediaItems: presenter.topRatedMovies, listName: Section.topRatedMoviesList.title,
                listSubtitle: Section.topRatedTVSeriesList.subtitle, didTapMediaItem: presenter.didTapMedia
            )
            sectionsAndTheirItems.append((Section.topRatedTVSeriesList, [.mediaListCell(topListVM)]))
        }
        
        if !presenter.nowPlayingMovies.isEmpty {
            let nowListVM = MediaListCellViewModel(
                mediaItems: presenter.nowPlayingMovies, listName: Section.nowPlayingMoviesList.title,
                listSubtitle: Section.nowPlayingMoviesList.subtitle, didTapMediaItem: presenter.didTapMedia
            )
            sectionsAndTheirItems.append((Section.nowPlayingMoviesList, [.mediaListCell(nowListVM)]))
        }
        
        self.visibleItems = sectionsAndTheirItems.map { $0.section }
        
        DispatchQueue.main.async {
            self.collectionView.applySnapshot(
                sections: self.visibleItems,
                itemsBySection: Dictionary(uniqueKeysWithValues: sectionsAndTheirItems)
            )
        }
    }
}

extension HomeScreenVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
        
        if contentOffsetY >= 5 && !isBlurToHeaderVisible {
            isBlurToHeaderVisible = true
            headerView.addBlur()
        }
        
        if contentOffsetY < 5 && isBlurToHeaderVisible {
            isBlurToHeaderVisible = false
            headerView.removeBlur()
        }
    }
}

extension HomeScreenVC: HomeScreenViewProtocol {
    func didRecieveAllMovies(popularMovies: [Movie], upcomingMovies: [Movie], topRatedMovies: [Movie], nowPlayingMovies: [Movie], allMovies: [Movie]) {
        var sectionsAndTheirItems: [(section: Section, items: [Item])] = []
        if !allMovies.isEmpty {
            let featuredVM = FeaturedMediaCellViewModel(media: allMovies, didTapMedia: self.presenter?.didTapMedia)
            sectionsAndTheirItems.append((Section.featured, [.featured(featuredVM)]))
        }
        
        if !popularMovies.isEmpty {
            let popularListVM = MediaListCellViewModel(
                mediaItems: popularMovies, listName: Section.popularMoviesList.title,
                listSubtitle: Section.popularMoviesList.subtitle, didTapMediaItem: self.presenter?.didTapMedia
            )
            sectionsAndTheirItems.append((Section.popularMoviesList, [.mediaListCell(popularListVM)]))
        }
        
        if !upcomingMovies.isEmpty {
            let upcomingListVM = MediaListCellViewModel(
                mediaItems: upcomingMovies, listName: Section.upcomingMoviesList.title,
                listSubtitle: Section.upcomingMoviesList.subtitle, didTapMediaItem: self.presenter?.didTapMedia
            )
            sectionsAndTheirItems.append((Section.upcomingMoviesList, [.mediaListCell(upcomingListVM)]))
        }
        
        if !topRatedMovies.isEmpty {
            let topListVM = MediaListCellViewModel(
                mediaItems: topRatedMovies, listName: Section.topRatedMoviesList.title,
                listSubtitle: Section.topRatedTVSeriesList.subtitle, didTapMediaItem: self.presenter?.didTapMedia
            )
            sectionsAndTheirItems.append((Section.topRatedTVSeriesList, [.mediaListCell(topListVM)]))
        }
        
        if !nowPlayingMovies.isEmpty {
            let nowListVM = MediaListCellViewModel(
                mediaItems: nowPlayingMovies, listName: Section.nowPlayingMoviesList.title,
                listSubtitle: Section.nowPlayingMoviesList.subtitle, didTapMediaItem: self.presenter?.didTapMedia
            )
            sectionsAndTheirItems.append((Section.nowPlayingMoviesList, [.mediaListCell(nowListVM)]))
        }
        
        self.visibleItems = sectionsAndTheirItems.map { $0.section }
        DispatchQueue.main.async {
            self.collectionView.applySnapshot(
                sections: self.visibleItems,
                itemsBySection: Dictionary(uniqueKeysWithValues: sectionsAndTheirItems)
            )
        }
    }
    
    func didRecieveError(_ errorStr: String) {
        let alert = UIAlertController(
            title: "Oops..",
            message: errorStr,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
