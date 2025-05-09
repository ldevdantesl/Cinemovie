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
    
    // MARK: - PROPERTIES
    var downloadingView: CMSplashView { get }
    var popUpView: PopUPView? { get set }
}

final class WatchlistScreenVC: UIViewController {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let headerViewHeight = 30.0 + UIConstants.topInset
    }
    
    // MARK: - SECTIONS
    enum Sections: Hashable {
        case watchlist
    }
    
    enum Items: Hashable {
        case zStackMediaListVM(WatchlistItemCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: WatchlistScreenPresenterProtocol?
    var popUpView: PopUPView?
    let downloadingView: CMSplashView = {
        let view = CMSplashView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - PROPERTIES
    private var isBlurToHeaderVisible: Bool = false
    
    // MARK: - VIEW PROPERTIES
    private lazy var refreshControler: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = CMColor.cmLabel
        control.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return control
    }()
    
    private lazy var headerView: WatchlistScreenHeaderView = {
        let headerVM = WatchlistScreenHeaderViewModel(didTapAddListAction: presenter?.didTapAddNewList)
        let view = WatchlistScreenHeaderView()
        view.configure(viewModel: headerVM)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: DiffableCollectionView = {
        let view = DiffableCollectionView<WatchlistScreenVC.Sections, WatchlistScreenVC.Items>(layout: createLayout(), ignoresTopSafeArea: false, showsTopBlur: false)
        view.delegate = self
        view.refreshControl = refreshControler
        view.register(cellClass: WatchlistItemCell.self)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        view.backgroundColor = CMColor.cmBackground
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        collectionView.configureDataSource { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .zStackMediaListVM(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? WatchlistItemCell
                cell?.configure(viewModel: vm)
                return cell
            }
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, env in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension: .estimated(200)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200)), subitem: item, count: 2)
            group.interItemSpacing = .fixed(20)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 10)
            return section
        }
    }
    
    // MARK: - OBJC
    @objc private func didPullToRefresh() {
        presenter?.didCallRefresh()
    }
}

extension WatchlistScreenVC: UICollectionViewDelegate {
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
        downloadingView.hide()
    }
}
