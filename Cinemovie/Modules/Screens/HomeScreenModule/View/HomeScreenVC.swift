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
        static let headerViewHeight = 70.0
    }
    
    enum HomeSection: Int, CaseIterable {
        case featured
        case popularList
        case upcomingList
        case topRatedList
        case nowPlayingList
        
        var titleForMovies: String{
            switch self {
            case .popularList: "Popular Movies"
            case .upcomingList: "Upcoming Movies"
            case .topRatedList: "Top Rated Movies"
            case .nowPlayingList: "Now Playing Movies"
            default: ""
            }
        }
        
        var subtitleForMovies: String? {
            switch self {
            case .popularList: "Popular Movies in your area"
            case .upcomingList: "Movies coming soon"
            case .topRatedList: "Worldwide top rated movies"
            case .nowPlayingList: "Now playing movies"
            default: nil
            }
        }
        
        var titleForTvSeries: String {
            switch self {
            case .popularList: "Popular TV Series & TV Shows"
            case .upcomingList: "Airing Today Series"
            case .topRatedList: "Top Rated Series"
            case .nowPlayingList: "On the Air Series"
            default: ""
            }
        }
        
        var subtitleForTvSeries: String? {
            switch self {
            case .popularList: "Popular Series & Shows in your area"
            case .upcomingList: "Series coming today"
            case .topRatedList: "Worldwide top rated Series"
            case .nowPlayingList: "Series currently broadcasting new episodes"
            default: nil
            }
        }
    }

    enum HomeItem: Hashable {
        case featured(FeaturedMediaCellViewModel)
        case mediaListCell(MediaListCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: HomeScreenPresenterProtocol?
    
    // MARK: - PROPERTIES
    private var viewModels: [CellViewModelBaseClass] = []
    private var headerViewHeightConstraint: Constraint?
    private var isBlurToHeaderVisible: Bool = false
    
    // MARK: - VIEW PROPERTIES
    private lazy var collectionView: DiffableCollectionView = {
        let view = DiffableCollectionView<HomeSection, HomeItem>(layout: createLayout())
        view.register(cellClass: FeaturedMediaCell.self)
        view.register(cellClass: MediaListCell.self)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = CMColor.cmBackground
        return view
    }()
    
    private lazy var headerView: HomeScreenHeaderView = {
        let view = HomeScreenHeaderView(viewModel: .init(headerTitle: "Discover", didTapMovieButton: switchToMovies, didTapTVSeriesButton: switchToTVShows))
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerViewHeightConstraint?.update(offset: Constants.headerViewHeight + view.safeAreaInsets.top + 5)
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
            headerViewHeightConstraint = $0.height.equalTo(Constants.headerViewHeight).constraint
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
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            let section = HomeSection.allCases[sectionIndex]
            
            switch section {
            case .featured: return self.sectionForFeatured()
            case .popularList: return self.sectionForMovieLists()
            case .upcomingList: return self.sectionForMovieLists()
            case .topRatedList: return self.sectionForMovieLists()
            case .nowPlayingList: return self.sectionForMovieLists()
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
        section.contentInsets = NSDirectionalEdgeInsets(top: Constants.headerViewHeight + 10, leading: 10, bottom: 10, trailing: 10)
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
        let featuredVM = FeaturedMediaCellViewModel(media: presenter.allTVSeries, didTapMedia: self.presenter?.didTapMedia)
        
        let popularListVM = MediaListCellViewModel(
            mediaItems: presenter.popularTVSeries, listName: HomeSection.popularList.titleForTvSeries,
            listSubtitle: HomeSection.popularList.subtitleForTvSeries, didTapMediaItem: presenter.didTapMedia
        )
        
        let upcomingListVM = MediaListCellViewModel(
            mediaItems: presenter.airingTodayTVSeries, listName: HomeSection.upcomingList.titleForTvSeries,
            listSubtitle: HomeSection.upcomingList.subtitleForTvSeries, didTapMediaItem: presenter.didTapMedia
        )
        
        let topListVM = MediaListCellViewModel(
            mediaItems: presenter.topRatedTVSeries, listName: HomeSection.topRatedList.titleForTvSeries,
            listSubtitle: HomeSection.topRatedList.subtitleForTvSeries, didTapMediaItem: presenter.didTapMedia
        )
        
        let nowListVM = MediaListCellViewModel(
            mediaItems: presenter.onTheAirTVSeries, listName: HomeSection.nowPlayingList.titleForTvSeries,
            listSubtitle: HomeSection.nowPlayingList.subtitleForTvSeries, didTapMediaItem: presenter.didTapMedia
        )
        
        DispatchQueue.main.async {
            self.collectionView.applySnapshot(
                sections: [.featured, .popularList, .upcomingList, .topRatedList, .nowPlayingList],
                itemsBySection: [
                    .featured : [.featured(featuredVM)],
                    .popularList : [.mediaListCell(popularListVM)],
                    .upcomingList : [.mediaListCell(upcomingListVM)],
                    .topRatedList : [.mediaListCell(topListVM)],
                    .nowPlayingList : [.mediaListCell(nowListVM)]
                ]
            )
        }

    }
    
    private func switchToMovies() {
        guard let presenter = presenter else { return }
        let featuredVM = FeaturedMediaCellViewModel(media: presenter.allMovies, didTapMedia: self.presenter?.didTapMedia)
        let popularListVM = MediaListCellViewModel(
            mediaItems: presenter.popularMovies, listName: HomeSection.popularList.titleForMovies,
            listSubtitle: HomeSection.popularList.subtitleForMovies, didTapMediaItem: presenter.didTapMedia
        )
        
        let upcomingListVM = MediaListCellViewModel(
            mediaItems: presenter.upcomingMovies, listName: HomeSection.upcomingList.titleForMovies,
            listSubtitle: HomeSection.upcomingList.subtitleForMovies, didTapMediaItem: presenter.didTapMedia
        )
        
        let topListVM = MediaListCellViewModel(
            mediaItems: presenter.topRatedMovies, listName: HomeSection.topRatedList.titleForMovies,
            listSubtitle: HomeSection.topRatedList.subtitleForMovies, didTapMediaItem: presenter.didTapMedia
        )
        
        let nowListVM = MediaListCellViewModel(
            mediaItems: presenter.nowPlayingMovies, listName: HomeSection.nowPlayingList.titleForMovies,
            listSubtitle: HomeSection.nowPlayingList.subtitleForMovies, didTapMediaItem: presenter.didTapMedia
        )
        
        DispatchQueue.main.async {
            self.collectionView.applySnapshot(
                sections: [.featured, .popularList, .upcomingList, .topRatedList, .nowPlayingList],
                itemsBySection: [
                    .featured : [.featured(featuredVM)],
                    .popularList : [.mediaListCell(popularListVM)],
                    .upcomingList : [.mediaListCell(upcomingListVM)],
                    .topRatedList : [.mediaListCell(topListVM)],
                    .nowPlayingList : [.mediaListCell(nowListVM)]
                ]
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
        let popularListVM = MediaListCellViewModel(
            mediaItems: popularMovies, listName: HomeSection.popularList.titleForMovies,
            listSubtitle: HomeSection.popularList.subtitleForMovies, didTapMediaItem: presenter?.didTapMedia
        )
        
        let upcomingListVM = MediaListCellViewModel(
            mediaItems: upcomingMovies, listName: HomeSection.upcomingList.titleForMovies,
            listSubtitle: HomeSection.upcomingList.subtitleForMovies, didTapMediaItem: presenter?.didTapMedia
        )
        
        let topListVM = MediaListCellViewModel(
            mediaItems: topRatedMovies, listName: HomeSection.topRatedList.titleForMovies,
            listSubtitle: HomeSection.topRatedList.subtitleForMovies, didTapMediaItem: presenter?.didTapMedia
        )
        
        let nowListVM = MediaListCellViewModel(
            mediaItems: nowPlayingMovies, listName: HomeSection.nowPlayingList.titleForMovies,
            listSubtitle: HomeSection.nowPlayingList.subtitleForMovies, didTapMediaItem: presenter?.didTapMedia
        )
        
        DispatchQueue.main.async {
            self.collectionView.applySnapshot(
                sections: [.featured, .popularList, .upcomingList, .topRatedList, .nowPlayingList],
                itemsBySection: [
                    .featured: [.featured(FeaturedMediaCellViewModel(media: allMovies, didTapMedia: self.presenter?.didTapMedia))],
                    .popularList: [.mediaListCell(popularListVM)],
                    .upcomingList: [.mediaListCell(upcomingListVM)],
                    .topRatedList: [.mediaListCell(topListVM)],
                    .nowPlayingList: [.mediaListCell(nowListVM)]
                ]
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
