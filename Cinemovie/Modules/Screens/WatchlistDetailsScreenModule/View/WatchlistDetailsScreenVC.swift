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
    func reloadData(newItems: [Media])
    func didReceievePaginatedItems(_ items: [Media], at indexPaths: [IndexPath])
    func didRecieveError(_ errorStr: String, goesBack: Bool)
    
    func showPaginatedLoading()
    func hidePaginatedLoading()
}

final class WatchlistDetailsScreenVC: UIViewController {
    // MARK: - VIPER
    var presenter: WatchlistDetailsScreenPresenterProtocol?
    let downloadView: CMSplashView = {
        let view = CMSplashView(frame: .zero, showsLoadingLabel: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - PROPERTIES
    private let listType: UserListTypes
    private var items: [Media] = []
    
    // MARK: - VIEW PROPERTIES
    lazy var refreshController: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didCallRefresh), for: .valueChanged)
        control.tintColor = CMColor.cmLabel
        return control
    }()
    
    private lazy var collectionView: TopBlurredCollectionView = {
        let view = TopBlurredCollectionView(layout: createLayout())
        view.register(cellClass: VerticalMediaListCell.self)
        view.refreshControl = refreshController
        view.dataSource = self
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
        presenter?.viewDidLoad()
        setupUI()
        downloadView.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - PRIVATE FUNC
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

extension WatchlistDetailsScreenVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.showBlur(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        let isAtBottom = offsetY + height >= contentHeight - 10
        isAtBottom ? presenter?.didCallPagination() : ()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: VerticalMediaListCell.identifier, for: indexPath
        ) as? VerticalMediaListCell else { return UICollectionViewCell() }
        let vm = VerticalMediaListCellViewModel(
            media: items, title: listType.title, subtitle: listType.subtitle,
            didTapBackButton: presenter?.didTapBackButton, didTapAnyMedia: presenter?.didTapAnyMedia
        )
        cell.configure(viewModel: vm)
        return cell
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
    
    
    func reloadData(newItems: [Media]) {
        self.items = newItems
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
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
