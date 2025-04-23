//
//  HomeScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import SnapKit
import UIKit

protocol HomeScreenViewProtocol: AnyObject {
    func didRecieveAllData(movieLists: [(listType: MovieListType, movies: [Movie])], trendingPeople: [Person])
    func didRecieveError(_ errorStr: String)
}

final class HomeScreenVC: UIViewController {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let featuredMovieHeight = UIConstants.screenHeight * 0.55
        static let headerViewHeight = 75.0 + UIConstants.topInset
        static let trendingPeopleIndexSection = 5
    }
    
    // MARK: - SECTION
    private enum Section: Hashable {
        case featured
        case movieList(MovieListType)
        case seriesList(TVSeriesListType)
        case trendingPeople
    }

    // MARK: - ITEM
    private enum Item: Hashable {
        case featured(FeaturedMediaCellViewModel)
        case mediaListCell(MediaListCellViewModel)
        case trendingPeopleCell(TrendingPeopleCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: HomeScreenPresenterProtocol?
    
    // MARK: - PROPERTIES
    private var headerViewHeightConstraint: Constraint?
    private var isBlurToHeaderVisible: Bool = false
    private var visibleItems: [Section] = []
    
    // MARK: - VIEW PROPERTIES
    private lazy var collectionView: DiffableCollectionView = {
        let view = DiffableCollectionView<HomeScreenVC.Section, HomeScreenVC.Item>(layout: createLayout(), showsTopBlur: false)
        view.register(cellClass: FeaturedMediaCell.self)
        view.register(cellClass: MediaListCell.self)
        view.register(cellClass: TrendingPeopleCell.self)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = CMColor.cmBackground
        return view
    }()
    
    private lazy var headerView: HomeScreenHeaderView = {
        let vm = HomeScreenHeaderViewModel(headerTitle: "Discover", didTapSearchButton: presenter?.didTapSearchButton) { [weak self] in
            guard let self = self else { return }
            self.switchTo($0)
        }
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
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.barTintColor = CMColor.cmBackground
        tabBarController?.tabBar.isTranslucent = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let cell = collectionView.visibleCells.first(where: { $0 is FeaturedMediaCell }) as? FeaturedMediaCell {
            cell.startMediaLoop()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let cell = collectionView.visibleCells.first(where: { $0 is FeaturedMediaCell }) as? FeaturedMediaCell {
            cell.stopTimer()
        }
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
                
            case .trendingPeopleCell(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? TrendingPeopleCell
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
            let homeSection = self.visibleItems[sectionIndex]
            let edgeInsets: NSDirectionalEdgeInsets
            
            switch homeSection {
            case .featured: edgeInsets = NSDirectionalEdgeInsets(top: Constants.headerViewHeight, leading: 10, bottom: 10, trailing: 10)
            default: edgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            }
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(Constants.featuredMovieHeight)))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: item.layoutSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = edgeInsets
            return section
        }
    }
    
    private func switchTo(_ mediaType: MediaTypes) {
        guard let presenter = presenter else { return }
        
        var sectionsAndItems: [(section: Section, items: [Item])] = []
        
        switch mediaType {
        case .movie:
            let featuredVM = FeaturedMediaCellViewModel(media: presenter.movieLists.flatMap { $0.movies }, didTapMedia: presenter.didTapMedia)
            sectionsAndItems.append((Section.featured, [.featured(featuredVM)]))
            
            let movieSections = generateListSections(
                from: presenter.movieLists.map { ($0.listType, $0.movies) },
                sectionBuilder: { .movieList($0) }
            )
            sectionsAndItems.append(contentsOf: movieSections)
            
        case .tvShow:
            let featuredVM = FeaturedMediaCellViewModel(media: presenter.seriesLists.flatMap { $0.series }, didTapMedia: presenter.didTapMedia)
            sectionsAndItems.append((Section.featured, [.featured(featuredVM)]))
            let seriesSections = generateListSections(
                from: presenter.seriesLists.map { ($0.listType, $0.series) },
                sectionBuilder: { .seriesList($0) }
            )
            sectionsAndItems.append(contentsOf: seriesSections)
        }
        
        let trendingPeopleVM = TrendingPeopleCellViewModel(people: presenter.trendingPeople, didTapPerson: presenter.didTapPerson)
        sectionsAndItems.insert((Section.trendingPeople, [.trendingPeopleCell(trendingPeopleVM)]), at: Constants.trendingPeopleIndexSection)
        
        visibleItems = sectionsAndItems.map(\.section)
        
        DispatchQueue.main.async {
            self.collectionView.applySnapshot(
                sections: self.visibleItems,
                itemsBySection: Dictionary(uniqueKeysWithValues: sectionsAndItems)
            )
        }
    }
    
    private func generateListSections<T: MediaListType, M: Media>(
        from lists: [(listType: T, media: [M])],
        sectionBuilder: (T) -> Section
    ) -> [(section: Section, items: [Item])] {
        var result: [(section: Section, items: [Item])] = []

        for (listType, media) in lists {
            if media.isEmpty { continue }

            let vm = MediaListCellViewModel(
                mediaItems: media,
                listName: listType.title,
                listSubtitle: listType.subtitle,
                didTapMediaItem: presenter?.didTapMedia
            )

            result.append((sectionBuilder(listType), [.mediaListCell(vm)]))
        }

        return result
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
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let featuredCell = cell as? FeaturedMediaCell {
            featuredCell.stopTimer()
        }
    }
}

extension HomeScreenVC: HomeScreenViewProtocol {
    func didRecieveAllData(movieLists: [(listType: MovieListType, movies: [Movie])], trendingPeople: [Person]) {
        var sectionsAndItems: [(section: Section, items: [Item])] = []

        let allMovies = movieLists.flatMap { $0.movies }
        let featuredVM = FeaturedMediaCellViewModel(media: allMovies, didTapMedia: self.presenter?.didTapMedia)
        sectionsAndItems.append((Section.featured, [.featured(featuredVM)]))
        
        let movieSections = generateListSections(
            from: movieLists.map { ($0.listType, $0.movies) },
            sectionBuilder: { .movieList($0) }
        )
        
        sectionsAndItems.append(contentsOf: movieSections)
        
        let trendingPeopleVM = TrendingPeopleCellViewModel(people: trendingPeople, didTapPerson: self.presenter?.didTapPerson)
        sectionsAndItems.insert((Section.trendingPeople, [.trendingPeopleCell(trendingPeopleVM)]), at: Constants.trendingPeopleIndexSection)
        
        visibleItems = sectionsAndItems.map(\.section)
        DispatchQueue.main.async {
            self.collectionView.applySnapshot(
                sections: self.visibleItems,
                itemsBySection: Dictionary(uniqueKeysWithValues: sectionsAndItems)
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
