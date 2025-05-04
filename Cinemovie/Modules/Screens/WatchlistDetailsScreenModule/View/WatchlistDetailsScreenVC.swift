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
    
    // MARK: - OTHER
    func reloadData(newItems: [Media])
    func didRecieveError(_ errorStr: String, goesBack: Bool)
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
    private var items: [Media] = []
    
    // MARK: - VIEW PROPERTIES
    private lazy var refreshControler: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didCallRefresh), for: .valueChanged)
        control.tintColor = CMColor.cmLabel
        return control
    }()
    
    private lazy var collectionView: TopBlurredCollectionView = {
        let view = TopBlurredCollectionView(layout: createLayout())
        view.register(cellClass: VerticalMediaListCell.self)
        view.refreshControl = refreshControler
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = CMColor.cmBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - LIFECYCLE
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: VerticalMediaListCell.identifier, for: indexPath
        ) as? VerticalMediaListCell else { return UICollectionViewCell() }
        let vm = VerticalMediaListCellViewModel(media: items, didTapAnyMedia: presenter?.didTapAnyMedia)
        cell.configure(viewModel: vm)
        return cell
    }
}

extension WatchlistDetailsScreenVC: WatchlistDetailsScreenViewProtocol {
    func reloadData(newItems: [Media]) {
        self.items = newItems
        collectionView.reloadData()
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
