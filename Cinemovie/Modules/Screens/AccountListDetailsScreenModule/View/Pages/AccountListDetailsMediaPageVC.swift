//
//  UserListDetailsMediaPageVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 11.05.2025.
//

import UIKit
import SnapKit

final class AccountListDetailsMediaPageVC: UIViewController {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 5.0
        static let aniDuration = 0.25
        static let itemWidth = (UIConstants.screenWidth / 3) - 40
        static let itemHeight = (itemWidth * 2)
        static let rightArrowImageName = "chevron.right"
        static let leftArrowImageName = "chevron.left"
    }
    
    // MARK: - SECTIONS
    enum Sections: Hashable {
        case main
        case notFound
    }
    
    enum Items: Hashable {
        case posterImageVM(MediaPosterImageCellViewModel)
        case unavailableVM(UnavailableInfoCellViewModel)
    }
    
    // MARK: - PROPERTIES
    lazy var subtitleForSupplementary = "Scroll \(mediaType == .movie ? "right" : "left") to see \(mediaType == .movie ? "TVSeries" : "Movies") if they exist"
    let mediaType: MediaTypes
    private var media: [Media]
    private weak var presenter: AccountListDetailsScreenPresenterProtocol?
    
    // MARK: - VIEW PROPERTIES
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.alpha = 0
        indicator.hidesWhenStopped = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var refreshController: UIRefreshControl = {
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(didCallRefresh), for: .valueChanged)
        refreshController.backgroundColor = .black
        refreshController.tintColor = CMColor.cmLabel
        return refreshController
    }()
    
    private lazy var collectionView: DiffableCollectionView = {
        let view = DiffableCollectionView<Sections, Items>(layout: createLayout(), ignoresTopSafeArea: false, showsTopBlur: false)
        view.backgroundColor = CMColor.cmBackground
        view.refreshControl = refreshController
        view.delegate = self
        view.register(cellClass: MediaPosterImageCell.self)
        view.register(cellClass: UnavailableInfoCell.self)
        view.registerSupplementaryHeaderItem(cellClass: SupplementaryHeaderCell.self)
        return view
    }()
    
    // MARK: - LIFECYCLE
    init(media: [Media], mediaType: MediaTypes, presenter: AccountListDetailsScreenPresenterProtocol?) {
        self.media = media
        self.mediaType = mediaType
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    init(presenter: AccountListDetailsScreenPresenterProtocol?) {
        self.media = []
        self.mediaType = .movie
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        guard !media.isEmpty else {
            let unavailableVM = UnavailableInfoCellViewModel(
                title: "Nothing added",
                subtitle: "Add any items to the list to see them here.",
                image: UIImage(named: ImageNames.addMovie.rawValue)
            )
            self.collectionView.applySnapshot(sections: [.notFound], itemsBySection: [.notFound : [.unavailableVM(unavailableVM)]])
            return
        }
        let mediaVMs = self.media.map { AccountListDetailsMediaPageVC.Items.posterImageVM(MediaPosterImageCellViewModel(media: $0, didTapMedia: presenter?.didTapAnyMedia) ) }
        self.collectionView.applySnapshot(sections: [.main], itemsBySection: [.main : mediaVMs])
    }
    
    // MARK: - PUBLIC FUNC
    public func applySnapshotWithNewMedia(_ media: [Media], paginating: Bool) {
        defer {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if paginating {
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.alpha = 0
                } else {
                    self.refreshController.endRefreshing()
                }
            }
        }
        
        guard !media.isEmpty else { return }
        if paginating { self.media.append(contentsOf: media) }
        else { self.media = media }
        
        let mediaVMs = self.media.map { AccountListDetailsMediaPageVC.Items.posterImageVM(MediaPosterImageCellViewModel(media: $0, didTapMedia: presenter?.didTapAnyMedia) ) }
        self.collectionView.applySnapshot(sections: [.main], itemsBySection: [.main : mediaVMs])
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        view.backgroundColor = CMColor.cmBackground
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60)),
            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
        )
        headerItem.pinToVisibleBounds = true
        headerItem.extendsBoundary = true
        
        config.boundarySupplementaryItems = [headerItem]
        
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }
            let currentSection = self.collectionView.snapshot().sectionIdentifiers[sectionIndex]
            
            guard currentSection == Sections.main else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: item.layoutSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 200, leading: 10, bottom: 10, trailing: 10)
                return section
            }
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(Constants.itemWidth), heightDimension: .absolute(Constants.itemHeight)))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Constants.itemHeight)),
                subitem: item, count: 3
            )
            group.interItemSpacing = .fixed(10)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            return section
        }, configuration: config)
    }
    
    private func configureDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .posterImageVM(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? MediaPosterImageCell
                cell?.configure(with: vm)
                return cell
                
            case .unavailableVM(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? UnavailableInfoCell
                cell?.configure(viewModel: vm)
                return cell
            }
        }
        
        collectionView.setSupplementaryViewProvider { [weak self] collectionView, elementKind, indexPath in
            guard let self = self else { return nil }
            guard let cell = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind, withReuseIdentifier: SupplementaryHeaderCell.identifier, for: indexPath
            ) as? SupplementaryHeaderCell else { return nil }
            let vm = SupplementaryHeaderViewModel(
                title: "\(self.presenter?.listType.title ?? "") \(mediaType.title)", subtitle: subtitleForSupplementary, showsTopShadow: true,
                leftButtonImageName: Constants.leftArrowImageName ,
                leftButtonTintColor: CMColor.cmAccent,
                didTapLeftButton: self.presenter?.didTapBackButton
            )
            cell.configure(viewModel: vm)
            return cell
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didCallRefresh() {
        presenter?.didCallRefresh(for: mediaType)
    }
}

extension AccountListDetailsMediaPageVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.media.count >= 20 else { return }
        guard !loadingIndicator.isAnimating else {
            loadingIndicator.alpha = 1
            return
        }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        let threshold = contentHeight - height
        let pullDistance = offsetY - threshold
        if pullDistance > 0 {
            let progress = min(pullDistance / 60, 1)
            loadingIndicator.alpha = progress
        } else {
            loadingIndicator.alpha = 0
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard self.media.count >= 20 else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 10 {
            loadingIndicator.startAnimating()
            presenter?.didCallPagination(for: mediaType)
        }
    }
}
