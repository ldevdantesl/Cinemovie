//
//  WatchlistDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit
import SnapKit

protocol WatchlistDetailsScreenViewProtocol: AnyObject {
    // MARK: - PROPERTIES
    var downloadView: CMSplashView { get }
    var refreshController: UIRefreshControl { get }
    
    // MARK: - OTHER
    func applySnapshot(sections: [WatchlistDetailsScreenVC.Sections], itemsBySection: [WatchlistDetailsScreenVC.Sections : [WatchlistDetailsScreenVC.Items]])
    func didReceievePaginatedItems(_ items: [Media], at indexPaths: [IndexPath])
    func didRecieveError(_ errorStr: String, goesBack: Bool)
    
    func showPaginatedLoading()
    func hidePaginatedLoading()
}

final class WatchlistDetailsScreenVC: UIViewController {
    // MARK: - SECTIONS
    enum Sections: Hashable {
        case media
        case notFound
    }
    
    enum Items: Hashable {
        case mediaList(VerticalMediaListCellViewModel)
        case notFound(UnavailableInfoCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: WatchlistDetailsScreenPresenterProtocol?
    let downloadView: CMSplashView = {
        let view = CMSplashView(frame: .zero, showsLoadingLabel: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - PROPERTIES
    private let listType: UserListTypes
    
    // MARK: - VIEW PROPERTIES
    lazy var refreshController: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didCallRefresh), for: .valueChanged)
        control.tintColor = CMColor.cmLabel
        return control
    }()
    
    private lazy var collectionView: DiffableCollectionView = {
        let view = DiffableCollectionView<Sections, Items>(layout: createLayout(), showsTopBlur: true)
        view.register(cellClass: VerticalMediaListCell.self)
        view.register(cellClass: UnavailableInfoCell.self)
        view.refreshControl = refreshController
        view.delegate = self
        view.backgroundColor = CMColor.cmBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - LIFECYCLE
    init(listType: UserListTypes) {
        self.listType = listType
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        downloadView.show()
        configureDataSource()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - PRIVATE FUNC
    private func configureDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .mediaList(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? VerticalMediaListCell
                cell?.configure(viewModel: vm)
                return cell
            case .notFound(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? UnavailableInfoCell
                cell?.configure(viewModel: vm)
                return cell
            }
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, env in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: item.layoutSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: UIConstants.topInset, leading: 10, bottom: 10, trailing: 10)
            return section
        }
    }
    
    private func setupUI() {
        view.backgroundColor = CMColor.cmBackground
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(downloadView)
        downloadView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - OBJC
    @objc private func didCallRefresh() {
        presenter?.didCallRefresh()
    }
}

extension WatchlistDetailsScreenVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.showBlur(scrollView)
        
        if (presenter?.media.count ?? 0) > 20 {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            let distanceFromBottom = offsetY + height - contentHeight
            
            if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? VerticalMediaListCell {
                let progress = min(distanceFromBottom / 100.0, 1.0)
                UIView.animate(withDuration: 0.15) {
                    cell.setLoadingAlpha(progress)
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        let isAtBottom = offsetY + height >= contentHeight - 10
        isAtBottom ? presenter?.didCallPagination() : ()
    }
}

extension WatchlistDetailsScreenVC: WatchlistDetailsScreenViewProtocol {
    func showPaginatedLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let cell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? VerticalMediaListCell else { return }
            cell.startPaginatingLoadingAnimation()
        }
    }
    
    func hidePaginatedLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let cell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? VerticalMediaListCell else { return }
            cell.stopPaginatingLoadingAnimation()
        }
    }
    
    func didReceievePaginatedItems(_ items: [any Media], at indexPaths: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? VerticalMediaListCell else { return }
            cell.insertNewItems(items, at: indexPaths)
        }
    }
    
    func applySnapshot(sections: [WatchlistDetailsScreenVC.Sections], itemsBySection: [WatchlistDetailsScreenVC.Sections : [WatchlistDetailsScreenVC.Items]]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.applySnapshot(sections: sections, itemsBySection: itemsBySection)
        }
    }
    
    func didRecieveError(_ errorStr: String, goesBack: Bool) {
        let alert = UIAlertController(title: "Oops...", message: errorStr, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            guard goesBack, let self = self else { return }
            self.presenter?.didTapBackButton()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
