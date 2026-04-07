//
//  HomeScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import SnapKit
import UIKit

protocol DiscoverScreenViewProtocol: AnyObject {
    func applySnapshot(sections: [DiscoverScreenVC.Sections], itemsBySection: [DiscoverScreenVC.Sections: [DiscoverScreenVC.Items]])
    func didRecieveError(_ errorStr: String)
    func didRefresh()
    func showDownloadingView()
    func hideDownloadingView()
}

final class DiscoverScreenVC: UIViewController {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let featuredMovieHeight = UIConstants.screenHeight * 0.7
        static let headerViewHeight = 75.0 + UIConstants.topInset
    }
    
    // MARK: - SECTION
    enum Sections: Hashable {
        case featured
        case movieList(MovieListType)
        case seriesList(TVSeriesListType)
        case trendingPeople
        case notFound
    }

    // MARK: - ITEM
    enum Items: Hashable {
        case featured(OneFeaturedMediaCellViewModel)
        case mediaListCell(MediaListCellViewModel)
        case trendingPeopleCell(TrendingPeopleCellViewModel)
        case notFoundCell(UnavailableInfoCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: DiscoverScreenPresenterProtocol?
    
    // MARK: - VIEW PROPERTIES
    private lazy var collectionView: DiffableCollectionView = {
        let view = DiffableCollectionView<DiscoverScreenVC.Sections, DiscoverScreenVC.Items>(layout: createLayout())
        view.register(cellClass: FeaturedMediaCell.self)
        view.register(cellClass: MediaListCell.self)
        view.register(cellClass: TrendingPeopleCell.self)
        view.register(cellClass: MediaSearchCell.self)
        view.register(cellClass: VerticalMediaListCell.self)
        view.register(cellClass: UnavailableInfoCell.self)
        view.register(cellClass: OneFeaturedMediaCell.self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = CMColor.cmBackground
        view.refreshControl = refreshControl
        return view
    }()
    
    private let downloadingView: CMSplashView = {
        let view = CMSplashView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = CMColor.cmLabel
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresh
    }()
    
    private lazy var headerView: DiscoverScreenHeaderView = {
        let vm = DiscoverScreenHeaderViewModel (
            currentMediaType: presenter?.currentMediaType ?? .movie,
            didTapSearchButton: { [weak self] in self?.presenter?.didTapSearch() },
            didTapMediaButton: { [weak self] in self?.presenter?.didChangeMediaType($0)}
        )
        let view = DiscoverScreenHeaderView(viewModel: vm)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        presenter?.viewDidLoaded()
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
        
        view.addSubview(downloadingView)
        downloadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, homeItem in
            switch homeItem {
            case .featured(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? OneFeaturedMediaCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .mediaListCell(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? MediaListCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .trendingPeopleCell(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? TrendingPeopleCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .notFoundCell(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? UnavailableInfoCell
                cell?.configure(viewModel: vm)
                return cell
            }
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            guard let self = self else { return nil }
            let homeSection = presenter?.visibleSections[sectionIndex] ?? Sections.featured
            let edgeInsets: NSDirectionalEdgeInsets
            let heightDimension: NSCollectionLayoutDimension
            
            switch homeSection {
            case .featured: edgeInsets = .zero
            case .notFound: edgeInsets = NSDirectionalEdgeInsets(top: UIConstants.screenHeight / 3, leading: 10, bottom: 10, trailing: 10)
            case .trendingPeople: edgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            default: edgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
            }
            
            switch homeSection {
            case .featured: heightDimension = .absolute(Constants.featuredMovieHeight)
            default: heightDimension = .estimated(Constants.featuredMovieHeight)
            }
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: heightDimension))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: item.layoutSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = edgeInsets
            return section
        }
    }
    
    @objc private func handleRefresh() {
        presenter?.didRefresh()
    }
}

extension DiscoverScreenVC: DiscoverScreenViewProtocol {
    func applySnapshot(sections: [Sections], itemsBySection: [Sections : [Items]]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.applySnapshot(sections: sections, itemsBySection: itemsBySection)
        }
    }
    
    func showDownloadingView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.downloadingView.show()
        }
    }
    
    func didRefresh() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    func hideDownloadingView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.downloadingView.hide()
        }
    }
    
    func didRecieveError(_ message: String) {
        guard presentedViewController == nil else { return }
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
