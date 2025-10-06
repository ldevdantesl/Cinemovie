//
//  SearchScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 13.06.2025
//

import UIKit
import SnapKit

protocol SearchScreenViewProtocol: AnyObject {
    func applySnapshot(sections: [SearchScreenVC.Sections], itemsBySection: [SearchScreenVC.Sections: [SearchScreenVC.Items]])
    func didRecieveError(_ errorStr: String)
    func showLoadingView()
    func hideLoadingView()
}

final class SearchScreenVC: UIViewController {
    
    // MARK: - CONSTANTS
    fileprivate enum Constants { }
    
    // MARK: - SECTIONS
    enum Sections: Hashable {
        case main
    }
    
    // MARK: - ITEMS
    enum Items: Hashable {
        case headerCell(SearchScreenHeaderCellViewModel)
        case mediaCell(VerticalMediaListCellViewModel)
    }
    
    // MARK: - VIEW PROPERTIES
    private lazy var collectionView = {
        let view = DiffableCollectionView<Sections, Items>(layout: createLayout(), ignoresTopSafeArea: false)
        view.register(cellClass: SearchScreenHeaderCell.self)
        view.register(cellClass: VerticalMediaListCell.self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = CMColor.cmBackground
        return view
    }()
    
    // MARK: - PRIVATE PROPERTIES
    private lazy var loadingView = CMSplashView(frame: .zero, showsLoadingLabel: true)
    
    // MARK: - VIPER
    var presenter: SearchScreenPresenterProtocol?

    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        presenter?.viewDidLoaded()
        setupUI()
    }
    
    // MARK: - PRIVATE METHODS
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: item.layoutSize,
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    private func configureDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, searchItem in
            switch searchItem {
            case .headerCell(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as?  SearchScreenHeaderCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .mediaCell(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? VerticalMediaListCell
                cell?.configure(viewModel: vm)
                return cell
            }
        }
    }
}

extension SearchScreenVC: SearchScreenViewProtocol {
    func applySnapshot(sections: [Sections], itemsBySection: [Sections : [Items]]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.applySnapshot(sections: sections, itemsBySection: itemsBySection)
        }
    }
    
    func showLoadingView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingView.show()
        }
    }
    
    func hideLoadingView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingView.hide()
        }
    }
    
    func didRecieveError(_ errorStr: String) {
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

