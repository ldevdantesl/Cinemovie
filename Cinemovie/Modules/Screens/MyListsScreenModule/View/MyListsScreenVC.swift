//
//  WatchlistScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit
import SnapKit

protocol MyListsScreenViewProtocol: AnyObject {
    // MARK: - FUNCTIONS
    func didRecieveError(_ description: String)
    func applySnapshot(sections: [MyListsScreenVC.Sections], itemsBySection: [MyListsScreenVC.Sections : [MyListsScreenVC.Items]])
    func refreshCompleted()
    
    // MARK: - LOADING
    func showDownloadingView()
    func hideDownloadingView()
    
    // MARK: - ERORR HANDLING
    func showError(errorStr: String)
    
    // MARK: - PROPERTIES
    var popUpView: PopUPView? { get set }
    var loadingBox: CMLoadingBox? { get set }
}

final class MyListsScreenVC: UIViewController {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let topDecorHeight = UIConstants.topInset
        static let plusButtonName = "plus"
        static let emptyReusableIdentifier = "empty"
    }
    
    enum SupplementaryKind {
        static let headerItem = "WatchlistScreenVC.headerItem"
        static let headerBlur = "WatchlistScreenVC.headerBlur"
    }
    
    // MARK: - SECTIONS
    enum Sections: Hashable {
        case accountLists
        case userLists
        case unauthorized
    }
    
    enum Items: Hashable {
        case accountListVM(AccountListCellViewModel)
        case userListVM(UserListCellViewModel)
        case authorizeVM(MyListsAuthenticateCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: MyListsScreenPresenterProtocol?
    var popUpView: PopUPView?
    var loadingBox: CMLoadingBox?
    
    // MARK: - PROPERTIES
    private let sectionStore = CMDiffableSectionStore<Sections>()
    
    // MARK: - VIEW PROPERTIES
    private let downloadingView: CMSplashView = {
        let view = CMSplashView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let topDecorLayer: CALayer = {
        let layer = CALayer()
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
        let layout = MyListsLayoutFactory.make(sectionStore: self.sectionStore)
        let view = DiffableCollectionView<MyListsScreenVC.Sections, MyListsScreenVC.Items>(layout: layout, ignoresTopSafeArea: false)
        view.refreshControl = refreshControler
        view.register(cellClass: AccountListCell.self)
        view.register(cellClass: UserListCell.self)
        view.register(cellClass: MyListsAuthenticateCell.self)
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: SupplementaryKind.headerBlur, withReuseIdentifier: Constants.emptyReusableIdentifier)
        view.register(TopBlurHeaderCell.self, forSupplementaryViewOfKind: SupplementaryKind.headerBlur, withReuseIdentifier: TopBlurHeaderCell.identifier)
        view.register(SupplementaryHeaderCell.self, forSupplementaryViewOfKind: SupplementaryKind.headerItem, withReuseIdentifier: SupplementaryHeaderCell.identifier)
        view.backgroundColor = CMColor.cmBackground
        return view
    }()

    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        presenter?.viewDidLoad(refreshing: false)
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
                
            case .authorizeVM(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath)
                (cell as? MyListsAuthenticateCell)?.configure(withVM: vm)
                return cell
                
            case .userListVM(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? UserListCell
                cell?.configure(viewModel: vm)
                return cell
            }
        }
        
        collectionView.setSupplementaryViewProvider { [weak self] collectionView, elementKind, indexPath in
            guard let self = self else { return nil }
            
            let section = sectionStore.section(at: indexPath.section)
            
            guard section != .unauthorized else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: Constants.emptyReusableIdentifier, for: indexPath)
            }
            
            guard elementKind == SupplementaryKind.headerItem else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: TopBlurHeaderCell.identifier, for: indexPath) as? TopBlurHeaderCell
            }
            
            guard let cell = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind, withReuseIdentifier: SupplementaryHeaderCell.identifier, for: indexPath
            ) as? SupplementaryHeaderCell else { return nil }
            
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
            default: break
            }
            return cell
        }
    }
    
    // MARK: - OBJC
    @objc private func didPullToRefresh() {
        presenter?.didCallRefresh()
    }
}

extension MyListsScreenVC: MyListsScreenViewProtocol {
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
        sectionStore.update(sections)
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
