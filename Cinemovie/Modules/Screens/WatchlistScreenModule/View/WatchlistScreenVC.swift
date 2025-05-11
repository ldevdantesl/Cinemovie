//
//  WatchlistScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit
import SnapKit

protocol WatchlistScreenViewProtocol: AnyObject {
    // MARK: - FUNCTIONS
    func didRecieveError(_ description: String)
    func applySnapshot(sections: [WatchlistScreenVC.Sections], itemsBySection: [WatchlistScreenVC.Sections : [WatchlistScreenVC.Items]])
    func refreshCompleted()
    
    // MARK: - LOADING
    func showDownloadingView()
    func hideDownloadingView()
    
    // MARK: - ERORR HANDLING
    func showError(errorStr: String)
    
    // MARK: - PROPERTIES
    var downloadingView: CMSplashView { get }
    var popUpView: PopUPView? { get set }
}

final class WatchlistScreenVC: UIViewController {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let topDecorHeight = UIConstants.topInset
        static let plusButtonName = "plus"
    }
    
    enum SupplementaryKind {
        static let headerItem = "WatchlistScreenVC.headerItem"
        static let headerBlur = "WatchlistScreenVC.headerBlur"
    }
    
    // MARK: - SECTIONS
    enum Sections: Hashable {
        case accountLists
        case userLists
    }
    
    enum Items: Hashable {
        case accountListVM(AccountListCellViewModel)
        case userListVM(UserListCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: WatchlistScreenPresenterProtocol?
    var popUpView: PopUPView?
    let downloadingView: CMSplashView = {
        let view = CMSplashView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - VIEW PROPERTIES
    private let topDecorLayer: CALayer = {
        let layer = CAGradientLayer()
        layer.backgroundColor = UIColor.black.cgColor
        layer.opacity = 0
        return layer
    }()
    
    private lazy var refreshControler: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = CMColor.cmLabel
        control.backgroundColor = .black
        control.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return control
    }()
    
    private lazy var collectionView: DiffableCollectionView = {
        let view = DiffableCollectionView<WatchlistScreenVC.Sections, WatchlistScreenVC.Items>(layout: createLayout(), ignoresTopSafeArea: false, showsTopBlur: false)
        view.delegate = self
        view.refreshControl = refreshControler
        view.register(cellClass: AccountListCell.self)
        view.register(cellClass: UserListCell.self)
        view.register(TopBlurHeaderCell.self, forSupplementaryViewOfKind: SupplementaryKind.headerBlur, withReuseIdentifier: TopBlurHeaderCell.identifier)
        view.register(SupplementaryHeaderCell.self, forSupplementaryViewOfKind: SupplementaryKind.headerItem, withReuseIdentifier: SupplementaryHeaderCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = CMColor.cmBackground
        return view
    }()

    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        presenter?.viewDidLoad()
        setupUI()
        view.layer.addSublayer(topDecorLayer)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
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
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(downloadingView)
        downloadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .accountListVM(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? AccountListCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .userListVM(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? UserListCell
                cell?.configure(viewModel: vm)
                return cell
            }
        }
        
        collectionView.setSupplementaryViewProvider { collectionView, elementKind, indexPath in
            guard elementKind == SupplementaryKind.headerItem else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: TopBlurHeaderCell.identifier, for: indexPath) as? TopBlurHeaderCell
            }
            
            guard let cell = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind, withReuseIdentifier: SupplementaryHeaderCell.identifier, for: indexPath
            ) as? SupplementaryHeaderCell else { return nil }
            let section = self.collectionView.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .accountLists:
                let vm = SupplementaryHeaderViewModel(title: "Account Lists", subtitle: "Default Lists for your account")
                cell.configure(viewModel: vm)
            case .userLists:
                let vm = SupplementaryHeaderViewModel(
                    title: "Custom Lists", subtitle: "Lists that you created",
                    buttonImageName: Constants.plusButtonName, buttonTintColor: CMColor.cmAccent
                ) { [weak self] in
                    guard let self = self else { return }
                    self.presenter?.didTapAddNewList()
                }
                cell.configure(viewModel: vm)
            }
            return cell
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)),
            elementKind: SupplementaryKind.headerBlur, alignment: .topLeading
        )
        headerItem.pinToVisibleBounds = true
        headerItem.extendsBoundary = false
        config.boundarySupplementaryItems = [headerItem]
        
        return UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, env in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension: .estimated(200)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200)), subitem: item, count: 2)
            group.interItemSpacing = .fixed(20)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)),
                elementKind: SupplementaryKind.headerItem, alignment: .topLeading
            )
            headerItem.pinToVisibleBounds = true
            section.boundarySupplementaryItems = [headerItem]
            return section
        }, configuration: config)
    }
    
    // MARK: - OBJC
    @objc private func didPullToRefresh() {
        presenter?.didCallRefresh()
    }
}

extension WatchlistScreenVC: UICollectionViewDelegate { }

extension WatchlistScreenVC: WatchlistScreenViewProtocol {
    // MARK: - ERROR HANDLING
    func didRecieveError(_ description: String) {
        let alert = UIAlertController(
            title: "Oops...", message: description,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - OTHER
    func applySnapshot(sections: [Sections], itemsBySection: [Sections : [Items]]) {
        collectionView.applySnapshot(sections: sections, itemsBySection: itemsBySection)
    }
    
    func refreshCompleted() {
        refreshControler.endRefreshing()
    }
    
    // MARK: - DOWNLOADING
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
    
    // MARK: - ERORR HANDLING
    func showError(errorStr: String) {
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
