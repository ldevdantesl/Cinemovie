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
    
    // MARK: - PROPERTIES
    var downloadingView: CMSplashView { get }
}

final class WatchlistScreenVC: UIViewController {

    // MARK: - CONSTANTS
    fileprivate enum Constants { }
    
    // MARK: - SECTIONS
    enum Sections: Hashable {
        case favorite
        case rated
        case watchlist
    }
    
    enum Items: Hashable {
        
    }
    
    // MARK: - ITEMS
    
    // MARK: - VIPER
    var presenter: WatchlistScreenPresenterProtocol?
    let downloadingView: CMSplashView = {
        let view = CMSplashView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - PROPERTIES
    
    // MARK: - VIEW PROPERTIES
    private lazy var collectionView: DiffableCollectionView = {
        let view = DiffableCollectionView<WatchlistScreenVC.Sections, WatchlistScreenVC.Items>(layout: createLayout(), showsBlur: false)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = CMColor.cmBackground
        return view
    }()

    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        configureDataSource()
        setupUI()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        view.backgroundColor = CMColor.cmBackground
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
        
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, env in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: item.layoutSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            return section
        }
    }
}

extension WatchlistScreenVC: UICollectionViewDelegate { }

extension WatchlistScreenVC: WatchlistScreenViewProtocol {
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
    
    func applySnapshot(sections: [Sections], itemsBySection: [Sections : [Items]]) {
        collectionView.applySnapshot(sections: sections, itemsBySection: itemsBySection)
    }
}
