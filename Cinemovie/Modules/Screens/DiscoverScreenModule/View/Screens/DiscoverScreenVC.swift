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
    
    var downloadingView: CMSplashView { get }
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
        case search
        case movieList(MovieListType)
        case seriesList(TVSeriesListType)
        case trendingPeople
        case recentlyViewed
        case notFound
    }

    // MARK: - ITEM
    enum Items: Hashable {
        case featured(OneFeaturedMediaCellViewModel)
        case mediaListCell(MediaListCellViewModel)
        case trendingPeopleCell(TrendingPeopleCellViewModel)
        case searchCell(MediaSearchCellViewModel)
        case notFoundCell(UnavailableInfoCellViewModel)
        case verticalMediaListCell(VerticalMediaListCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: DiscoverScreenPresenterProtocol?
    let downloadingView: CMSplashView = {
        let view = CMSplashView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - PROPERTIES
    private var headerViewHeightConstraint: Constraint?
    private var isBlurToHeaderVisible: Bool = false
    
    // MARK: - VIEW PROPERTIES
    private lazy var collectionView: DiffableCollectionView = {
        let view = DiffableCollectionView<DiscoverScreenVC.Sections, DiscoverScreenVC.Items>(layout: createLayout(), showsTopBlur: true)
        view.register(cellClass: FeaturedMediaCell.self)
        view.register(cellClass: MediaListCell.self)
        view.register(cellClass: TrendingPeopleCell.self)
        view.register(cellClass: MediaSearchCell.self)
        view.register(cellClass: VerticalMediaListCell.self)
        view.register(cellClass: UnavailableInfoCell.self)
        view.register(cellClass: OneFeaturedMediaCell.self)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = CMColor.cmBackground
        return view
    }()
    
    private lazy var headerView: DiscoverScreenHeaderView = {
        let vm = DiscoverScreenHeaderViewModel(didTapSearchButton: nil, didTapMediaButton: presenter?.didChangeMediaType)
        let view = DiscoverScreenHeaderView(viewModel: vm)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoaded()
        configureDataSource()
        self.downloadingView.show()
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
                
            case .searchCell(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? MediaSearchCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .notFoundCell(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? UnavailableInfoCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .verticalMediaListCell(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? VerticalMediaListCell
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
            case .search, .recentlyViewed: edgeInsets = NSDirectionalEdgeInsets(top: Constants.headerViewHeight, leading: 10, bottom: 10, trailing: 10)
            case .notFound: edgeInsets = NSDirectionalEdgeInsets(top: UIConstants.screenHeight / 3, leading: 10, bottom: 10, trailing: 10)
            default: edgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
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
}

extension DiscoverScreenVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.showBlur(scrollView)
    }
}

extension DiscoverScreenVC: DiscoverScreenViewProtocol {
    func applySnapshot(sections: [Sections], itemsBySection: [Sections : [Items]]) {
        DispatchQueue.main.async {
            self.collectionView.applySnapshot(sections: sections, itemsBySection: itemsBySection)
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
