//
//  UserListDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 14.05.2025
//

import UIKit
import SnapKit

protocol UserListDetailsScreenViewProtocol: AnyObject {
    // MARK: - OTHER
    func applySnapshot(sections: [UserListDetailsScreenVC.Sections], itemsBySection: [UserListDetailsScreenVC.Sections : [UserListDetailsScreenVC.Items]])
    
    // MARK: - DOWNLOADING
    func showDownloadingView()
    func hideDownloadingView()
    func hidePaginationLoadingIndicator()
    
    func stopRefreshing()
    
    // MARK: - ERROR HANDLING
    func didReceiveError(_ errorStr: String, goesBack: Bool)
}

final class UserListDetailsScreenVC: UIViewController {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 5.0
        static let aniDuration = 0.25
        static let itemWidth = (UIConstants.screenWidth / 3) - 40
        static let itemHeight = (itemWidth * 2)
        static let rightArrowImageName = "square.and.arrow.up"
        static let leftArrowImageName = "chevron.left"
        static let topDecorHeight = UIConstants.topInset
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
    
    // MARK: - VIPER
    var presenter: UserListDetailsScreenPresenterProtocol?
    
    // MARK: - VIEW PROPERTIES
    private let topDecorLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        layer.opacity = 0
        return layer
    }()
    
    private let downloadingView: CMSplashView = {
        let view = CMSplashView(frame: .zero, showsLoadingLabel: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        let view = DiffableCollectionView<Sections, Items>(layout: createLayout(), ignoresTopSafeArea: false)
        view.backgroundColor = CMColor.cmBackground
        view.refreshControl = refreshController
        view.delegate = self
        view.register(cellClass: MediaPosterImageCell.self)
        view.register(cellClass: UnavailableInfoCell.self)
        view.registerSupplementaryHeaderItem(cellClass: SupplementaryHeaderCell.self)
        return view
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        presenter?.viewDidLoad()
        view.layer.addSublayer(topDecorLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.topDecorLayer.frame = CGRect(
            x: 0, y: 0,
            width: view.bounds.width,
            height: Constants.topDecorHeight
        )
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
        
        view.addSubview(downloadingView)
        downloadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)),
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
            guard let self = self, let presenter = self.presenter else { return nil }
            guard let cell = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind, withReuseIdentifier: SupplementaryHeaderCell.identifier, for: indexPath
            ) as? SupplementaryHeaderCell else { return nil }
            let vm = SupplementaryHeaderViewModel(
                title: presenter.getListName(),
                subtitle: "Movies & TV Series of the list",
                showsTopShadow: true,
                rightButtonImageName: Constants.rightArrowImageName,
                rightButtonTintColor: CMColor.cmAccent,
                didTapRightButton: self.presenter?.didTapShareList,
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
        presenter?.didCallRefresh()
    }
}

extension UserListDetailsScreenVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let presenter = presenter, presenter.media.count >= 20 else { return }
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
        guard let presenter = presenter, presenter.media.count >= 20 else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 10 {
            loadingIndicator.startAnimating()
            presenter.didCallPagination()
        }
    }
}

extension UserListDetailsScreenVC: UserListDetailsScreenViewProtocol {
    func applySnapshot(sections: [Sections], itemsBySection: [Sections : [Items]]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.applySnapshot(sections: sections, itemsBySection: itemsBySection)
        }
    }
    
    func showDownloadingView() {
        self.view.bringSubviewToFront(downloadingView)
        downloadingView.show()
    }
    
    func hideDownloadingView() {
        downloadingView.hide {
            UIView.animate(withDuration: 2) { [weak self] in
                guard let self = self else { return }
                self.topDecorLayer.opacity = 1
            }
        }
    }
    
    func hidePaginationLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
        }
    }
    
    func stopRefreshing() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.refreshController.endRefreshing()
        }
    }
    
    // MARK: - ERROR HANDLING
    func didReceiveError(_ errorStr: String, goesBack: Bool) {
        let alert = UIAlertController(title: "Oopss...", message: errorStr, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            goesBack ? self.presenter?.didTapBackButton() : ()
        }
        alert.addAction(action)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.present(alert, animated: true)
        }
    }
}
