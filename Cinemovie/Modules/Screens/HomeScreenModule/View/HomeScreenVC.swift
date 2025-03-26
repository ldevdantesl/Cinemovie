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
        case popular, upcoming, topRated, nowPlaying
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
            let section = HomeSection.allCases[indexPath.section]
            let cell = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind, withReuseIdentifier: MediaListsHeaderCell.identifier, for: indexPath
            ) as? MediaListsHeaderCell
            
            switch section {
            case .popular:
                let vm = MediaListsHeaderCellViewModel(titleText: "Popular Movies", subtitleText: "Popular movies in your area")
                cell?.configure(with: vm)
            case .upcoming:
                let vm = MediaListsHeaderCellViewModel(titleText: "Upcoming Movies", subtitleText: "Movies to come soon")
                cell?.configure(with: vm)
            case .topRated:
                let vm = MediaListsHeaderCellViewModel(titleText: "Top Rated Movies", subtitleText: "Worldwide top rated movies")
                cell?.configure(with: vm)
            case .nowPlaying:
                let vm = MediaListsHeaderCellViewModel(titleText: "Now Playing Movies", subtitleText: "Movies now playing in your area")
                cell?.configure(with: vm)
            default: return nil
            }
            
            return cell
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            let section = HomeSection.allCases[sectionIndex]
            
            switch section {
            case .featured: return self.sectionForFeatured()
            case .popular: return self.sectionForMovieLists()
            case .upcoming: return self.sectionForMovieLists()
            case .topRated: return self.sectionForMovieLists()
            case .nowPlaying: return self.sectionForMovieLists()
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
                sections: [.featured, .popular, .upcoming, .topRated, .nowPlaying],
                itemsBySection: [
                    .featured : [.featured(FeaturedMediaCellViewModel(media: presenter.allTVSeries))],
                    .popular : presenter.popularTVSeries.map { .posterCell(MediaPosterImageCellViewModel(media: $0)) },
                    .upcoming : presenter.onTheAirTVSeries.map { .posterCell(MediaPosterImageCellViewModel(media: $0)) },
                    .topRated : presenter.topRatedTVSeries.map { .posterCell(MediaPosterImageCellViewModel(media: $0)) },
                    .nowPlaying : presenter.airingTodayTVSeries.map { .posterCell(MediaPosterImageCellViewModel(media: $0)) },
                ]
            )
        }
    }
    
    private func switchToMovies() {
        guard let presenter = presenter else { return }
        DispatchQueue.main.async {
            self.collectionView.applySnapshot(
                sections: [.featured, .popular, .upcoming, .topRated, .nowPlaying],
                itemsBySection: [
                    .featured : [.featured(FeaturedMediaCellViewModel(media: presenter.allMovies))],
                    .popular : presenter.popularMovies.map { .posterCell(MediaPosterImageCellViewModel(media: $0)) },
                    .upcoming : presenter.upcomingMovies.map { .posterCell(MediaPosterImageCellViewModel(media: $0)) },
                    .topRated : presenter.topRatedMovies.map { .posterCell(MediaPosterImageCellViewModel(media: $0)) },
                    .nowPlaying : presenter.nowPlayingMovies.map { .posterCell(MediaPosterImageCellViewModel(media: $0)) },
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
                sections: [.featured, .popular, .upcoming, .topRated, .nowPlaying],
                itemsBySection: [
                    .featured: [.featured(FeaturedMediaCellViewModel(media: allMovies))],
                    .popular: popularMovies.map { .posterCell(MediaPosterImageCellViewModel(media: $0, didTapMedia: self.presenter?.didTapMovie)) },
                    .upcoming: upcomingMovies.map { .posterCell(MediaPosterImageCellViewModel(media: $0, didTapMedia: self.presenter?.didTapMovie)) },
                    .topRated: topRatedMovies.map { .posterCell(MediaPosterImageCellViewModel(media: $0, didTapMedia: self.presenter?.didTapMovie)) },
                    .nowPlaying: nowPlayingMovies.map { .posterCell(MediaPosterImageCellViewModel(media: $0, didTapMedia: self.presenter?.didTapMovie)) }
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
