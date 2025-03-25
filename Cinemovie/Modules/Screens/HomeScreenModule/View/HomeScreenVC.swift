//
//  HomeScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import SnapKit
import UIKit

protocol HomeScreenViewProtocol: AnyObject {
    func didRecievePopularMovies(_ movies: [Movie])
    func didRecieveTopRatedMovies(_ movies: [Movie])
    func didRecieveUpcomingMovies(_ movies: [Movie])
    func didRecieveNowPlayingMovies(_ movies: [Movie])

    func didRecieveError(_ errorStr: String)
}

final class HomeScreenVC: UIViewController {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let featuredMovieViewHorPadding = 20
        static let headerViewHeight = 70.0
        static let headerViewTopMargin: CGFloat = 15
        static let featuredMovieHeight = UIConstants.screenHeight * 0.55
        static let mediaListViewHeight: CGFloat = 200
    }
    
    enum HomeSection: Int, CaseIterable {
        case featured
        case popular
    }

    enum HomeItem: Hashable {
        case featured([Movie])
        case mediaList(MediaListCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: HomeScreenPresenterProtocol?
    
    // MARK: - VIEW PROPERTIES
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = CMColor.cmBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<HomeSection, HomeItem>!
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        presenter?.viewDidLoaded()
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
            $0.edges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = HomeSection(rawValue: sectionIndex) else { return nil }
            switch section {
            case .featured: return self.featuredMovieSection()
            case .popular:
                let height = MediaListCellViewModel.calculateCellHeight(listSubtitle: nil)
                return self.verticalListSection(height: height)
            }
        }
    }
    
    private func featuredMovieSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(UIConstants.screenHeight * 0.55)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func verticalListSection(height: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(height)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0)
        return section
    }
    
    private func configureDataSource() {
        let featuredCellRegistration = UICollectionView.CellRegistration<FeaturedMovieCell, [Movie]> { cell, indexPath, movies in
            let viewModel = FeaturedMovieViewModel(movies: movies)
            cell.configure(viewModel: viewModel)
        }
        
        let mediaListCellRegistration = UICollectionView.CellRegistration<MediaListCell, MediaListCellViewModel> { cell, indexPath, viewModel in
            cell.configure(viewModel: viewModel)
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>(collectionView: collectionView){ collectionView, indexPath, item in
            switch item {
            case .featured(let movies): return collectionView.dequeueConfiguredReusableCell(using: featuredCellRegistration, for: indexPath, item: movies)
            case .mediaList(let vm): return collectionView.dequeueConfiguredReusableCell(using: mediaListCellRegistration, for: indexPath, item: vm)
            }
        }
    }
    
    private func applySnapshot(featuredMovies: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        snapshot.appendSections([.featured])
        snapshot.appendItems([.featured(featuredMovies)], toSection: .featured)
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func applySnapshot(viewModel: MediaListCellViewModel, to section: HomeSection) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        snapshot.appendSections([.popular])
        snapshot.appendItems([.mediaList(viewModel)], toSection: section)
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension HomeScreenVC: HomeScreenViewProtocol {
    func didRecievePopularMovies(_ movies: [Movie]) {
        DispatchQueue.main.async {
            let viewModel = MediaListCellViewModel(movies: movies, listTitle: "Popular")
            var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
            snapshot.appendSections([.featured, .popular])
            snapshot.appendItems([.featured(movies)], toSection: .featured)
            snapshot.appendItems([.mediaList(viewModel)], toSection: .popular)
            self.diffableDataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func didRecieveTopRatedMovies(_ movies: [Movie]) { }
    
    func didRecieveUpcomingMovies(_ movies: [Movie]) { }
    
    func didRecieveNowPlayingMovies(_ movies: [Movie]) { }

    func didRecieveError(_ errorStr: String) {
        let alert = UIAlertController(
            title: "Oops..",
            message: errorStr,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "OK", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
}
