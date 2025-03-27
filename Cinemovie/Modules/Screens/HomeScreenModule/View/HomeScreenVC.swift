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
        case popularMovies, upcomingMovies, topRatedMovies, nowPlayingMovies
        case popularTVSeries, onTheAirTVSeries, topRatedTVSeries, airingTodayTVSeries
    }

    enum HomeItem: Hashable {
        case featured(FeaturedMediaCellViewModel)
        case posterCell(MediaPosterImageCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: HomeScreenPresenterProtocol?
    
    // MARK: - PROPERTIES
    private var viewModels: [CellViewModel] = []
    private var headerViewHeightConstraint: Constraint?
    private var isBlurToHeaderVisible: Bool = false
    
    // MARK: - VIEW PROPERTIES
    private lazy var collectionView: CMCollectionView = {
        let view = CMCollectionView<HomeSection, HomeItem>(layout: createLayout())
        view.registerSupplementaryHeaderItem(cellClass: MediaListsHeaderCell.self)
        view.register(cellClass: FeaturedMediaCell.self)
        view.register(cellClass: MediaPosterImageCell.self)
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
                
            case .posterCell(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? MediaPosterImageCell
                cell?.configure(with: vm)
                return cell
            }
        }
        
        collectionView.setSupplementaryViewProvider { collectionView, elementKind, indexPath in
            let snapshot = self.collectionView.diffableDataSource.snapshot()
            let section = snapshot.sectionIdentifiers[indexPath.section]
                
            let cell = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind, withReuseIdentifier: MediaListsHeaderCell.identifier, for: indexPath
            ) as? MediaListsHeaderCell
            
            let titleText: String
            let subtitleText: String
            switch section {
            case .popularMovies: titleText = "Popular Movies"; subtitleText = "Popular movies in your area"
            case .upcomingMovies: titleText = "Upcoming Movies"; subtitleText = "Movies to come soon"
            case .topRatedMovies: titleText = "Top Rated Movies"; subtitleText = "Worldwide top rated movies"
            case .nowPlayingMovies: titleText = "Now Playing Movies"; subtitleText = "Movies now playing in your area"
            case .popularTVSeries: titleText = "Popular Series"; subtitleText = "Series popular in your area"
            case .onTheAirTVSeries: titleText = "On the Air Series"; subtitleText = "Series currently broadcasting new episodes"
            case .topRatedTVSeries: titleText = "Top Rated Series"; subtitleText = "Top rated series in your area"
            case .airingTodayTVSeries: titleText = "Airing Today Series"; subtitleText = "Series airing today"
            default: return nil
            }
            
            let vm = MediaListsHeaderCellViewModel(titleText: titleText, subtitleText: subtitleText)
            cell?.configure(with: vm)
            return cell
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            let section = HomeSection.allCases[sectionIndex]
            
            switch section {
            case .featured: return self.sectionForFeatured()
            case .popularMovies: return self.sectionForMovieLists()
            case .upcomingMovies: return self.sectionForMovieLists()
            case .topRatedMovies: return self.sectionForMovieLists()
            case .nowPlayingMovies: return self.sectionForMovieLists()
            case .popularTVSeries: return self.sectionForMovieLists()
            case .airingTodayTVSeries: return self.sectionForMovieLists()
            case .onTheAirTVSeries: return self.sectionForMovieLists()
            case .topRatedTVSeries: return self.sectionForMovieLists()
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
        let itemWidth = UIConstants.screenWidth / 3
        let itemHeight = itemWidth * 1.3
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/3), heightDimension: .absolute(itemHeight)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(itemHeight)), subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func switchToTVShows() {
        guard let presenter = presenter else { return }
        DispatchQueue.main.async {
            self.collectionView.applySnapshot(
                sections: [.featured, .popularTVSeries, .onTheAirTVSeries, .topRatedTVSeries, .airingTodayTVSeries],
                itemsBySection: [
                    .featured : [.featured(FeaturedMediaCellViewModel(media: presenter.allTVSeries, didTapMedia: self.presenter?.didTapMedia))],
                    .popularTVSeries : presenter.popularTVSeries.map { .posterCell(MediaPosterImageCellViewModel(media: $0, didTapMedia: self.presenter?.didTapMedia)) },
                    .onTheAirTVSeries : presenter.onTheAirTVSeries.map { .posterCell(MediaPosterImageCellViewModel(media: $0, didTapMedia: self.presenter?.didTapMedia)) },
                    .topRatedTVSeries : presenter.topRatedTVSeries.map { .posterCell(MediaPosterImageCellViewModel(media: $0, didTapMedia: self.presenter?.didTapMedia)) },
                    .airingTodayTVSeries : presenter.airingTodayTVSeries.map { .posterCell(MediaPosterImageCellViewModel(media: $0, didTapMedia: self.presenter?.didTapMedia)) },
                ]
            )
        }
    }
    
    private func switchToMovies() {
        guard let presenter = presenter else { return }
        DispatchQueue.main.async {
            self.collectionView.applySnapshot(
                sections: [.featured, .popularMovies, .upcomingMovies, .topRatedMovies, .nowPlayingMovies],
                itemsBySection: [
                    .featured : [.featured(FeaturedMediaCellViewModel(media: presenter.allMovies, didTapMedia: self.presenter?.didTapMedia))],
                    .popularMovies : presenter.popularMovies.map { .posterCell(MediaPosterImageCellViewModel(media: $0, didTapMedia: self.presenter?.didTapMedia)) },
                    .upcomingMovies : presenter.upcomingMovies.map { .posterCell(MediaPosterImageCellViewModel(media: $0, didTapMedia: self.presenter?.didTapMedia)) },
                    .topRatedMovies : presenter.topRatedMovies.map { .posterCell(MediaPosterImageCellViewModel(media: $0, didTapMedia: self.presenter?.didTapMedia)) },
                    .nowPlayingMovies : presenter.nowPlayingMovies.map { .posterCell(MediaPosterImageCellViewModel(media: $0, didTapMedia: self.presenter?.didTapMedia)) },
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
        DispatchQueue.main.async {
            self.collectionView.applySnapshot(
                sections: [.featured, .popularMovies, .upcomingMovies, .topRatedMovies, .nowPlayingMovies],
                itemsBySection: [
                    .featured: [.featured(FeaturedMediaCellViewModel(media: allMovies, didTapMedia: self.presenter?.didTapMedia))],
                    .popularMovies: popularMovies.map { .posterCell(MediaPosterImageCellViewModel(media: $0, didTapMedia: self.presenter?.didTapMedia)) },
                    .upcomingMovies: upcomingMovies.map { .posterCell(MediaPosterImageCellViewModel(media: $0, didTapMedia: self.presenter?.didTapMedia)) },
                    .topRatedMovies: topRatedMovies.map { .posterCell(MediaPosterImageCellViewModel(media: $0, didTapMedia: self.presenter?.didTapMedia)) },
                    .nowPlayingMovies: nowPlayingMovies.map { .posterCell(MediaPosterImageCellViewModel(media: $0, didTapMedia: self.presenter?.didTapMedia)) }
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
