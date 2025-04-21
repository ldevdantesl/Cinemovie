//
//  PersonDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 20.03.2025
//

import UIKit
import SnapKit
import SDWebImage

protocol PersonDetailsScreenViewProtocol: AnyObject {
    func didRecieveError(_ errorStr: String)
    func didGetAllPersonData(
        _ details: PersonDetails, sources: ExternalSource,
        movies: [Movie], tvSeries: [TVSeries]
    )
}

final class PersonDetailsScreenVC: UIViewController {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let collectionViewSpacing = 10.0
        static let aniDuration = 1.0
        static let defaultCellHeight = 100.0
    }
    
    // MARK: - SECTIONS
    fileprivate enum Sections: Hashable {
        case header
        case overview
        case movies
        case tvSeries
        case unavailable
    }
    
    fileprivate enum Items: Hashable {
        case headerVM(PersonInfoCellViewModel)
        case overviewVM(OverviewCellViewModel)
        case mediaListVM(MediaListCellViewModel)
        case unavailableVM(UnavailableInfoCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: PersonDetailsScreenPresenterProtocol?
    
    // MARK: - PROPERTIES
    private var visibleSections: [Sections] = []
    private var cachedCollectionViewCellSize: [IndexPath : CGSize] = [:]
    private lazy var isFirstScreen = navigationController?.viewControllers.count ?? 0 > 1
    
    // MARK: - VIEW PROPERTIES
    private let downloadingView: CMSplashView = {
        let splash = CMSplashView(frame: .zero, showsLoadingLabel: true)
        splash.translatesAutoresizingMaskIntoConstraints = false
        return splash
    }()
    
    private lazy var collectionView: DiffableCollectionView = {
        let cv = DiffableCollectionView<Sections, Items>(layout: createLayout(), showsTopBlur: true)
        cv.layer.zPosition = 0
        cv.register(cellClass: PersonInfoCell.self)
        cv.register(cellClass: MediaListCell.self)
        cv.register(cellClass: OverviewCell.self)
        cv.register(cellClass: UnavailableInfoCell.self)
        cv.delegate = self
        cv.backgroundColor = CMColor.cmBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
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
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadingView.show()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SDImageCache.shared.clearMemory()
    }
    
    deinit {
        print("Person Details Screen deinit")
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        view.addSubview(downloadingView)
        downloadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.bringSubviewToFront(downloadingView)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            guard let self = self else {
                return NSCollectionLayoutSection(group: .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))))
            }
            
            let detailsSection = self.visibleSections[sectionIndex]
            let edgeInsets: NSDirectionalEdgeInsets
            
            switch detailsSection {
            case .header: edgeInsets = .init(top: UIConstants.topInset, leading: 10, bottom: 10, trailing: 10)
            default: edgeInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            }
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200)))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: item.layoutSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = edgeInsets
            return section
        }
    }
    
    private func configureDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .headerVM(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonInfoCell.identifier, for: indexPath) as? PersonInfoCell
                cell?.configure(viewModel: vm)
                return cell
            case .overviewVM(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OverviewCell.identifier, for: indexPath) as? OverviewCell
                cell?.configure(with: vm)
                return cell
            case .mediaListVM(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaListCell.identifier, for: indexPath) as? MediaListCell
                cell?.configure(viewModel: vm)
                return cell
            case .unavailableVM(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnavailableInfoCell.identifier, for: indexPath) as? UnavailableInfoCell
                cell?.configure(viewModel: vm)
                return cell
            }
        }
    }
}

extension PersonDetailsScreenVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.showBlur(scrollView)
    }
}

extension PersonDetailsScreenVC: PersonDetailsScreenViewProtocol {
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
            self.present(alert, animated: true)
        }
    }
    
    func didGetAllPersonData(
        _ details: PersonDetails, sources: ExternalSource,
        movies: [Movie], tvSeries: [TVSeries]
    ) {
        self.downloadingView.hide()
        var sectionsAndTheirItems: [(section: Sections, items: [Items])] = []
        
        let infoVM = PersonInfoCellViewModel(
            personDetails: details, externalSource: sources,
            didTapBackButton: presenter?.didTapBackButton, didTapSource: presenter?.didTapLogoImage
        )
        sectionsAndTheirItems.append((Sections.header, [.headerVM(infoVM)]))
        let overviewVM = OverviewCellViewModel(overviewText: details.biography)
        sectionsAndTheirItems.append((Sections.overview, [.overviewVM(overviewVM)]))
        
        if !movies.isEmpty {
            let moviesVM = MediaListCellViewModel(
                mediaItems: movies, listName: "Movies",
                listSubtitle: "Movies in which \(details.name) has played", didTapMediaItem: presenter?.didTapMedia
            )
            sectionsAndTheirItems.append((Sections.movies, [.mediaListVM(moviesVM)]))
        }
        
        if !tvSeries.isEmpty {
            let seriesVM = MediaListCellViewModel(
                mediaItems: tvSeries, listName: "TV Series",
                listSubtitle: "TV Series in which \(details.name) has played", didTapMediaItem: presenter?.didTapMedia
            )
            sectionsAndTheirItems.append((Sections.tvSeries, [.mediaListVM(seriesVM)]))
        }
        
        if movies.isEmpty && tvSeries.isEmpty {
            let unavailableVm = UnavailableInfoCellViewModel(
                title: "Additional information is not available",
                subtitle: "We couldn't find any movies or TV series linked to this person.",
                image: UIImage(named: ImageNames.empty.rawValue)
            )
            sectionsAndTheirItems.append((Sections.unavailable, [.unavailableVM(unavailableVm)]))
        }
        
        self.visibleSections = sectionsAndTheirItems.map { $0.section }
        collectionView.applySnapshot(
            sections: self.visibleSections,
            itemsBySection: Dictionary(uniqueKeysWithValues: sectionsAndTheirItems)
        )
    }
}
