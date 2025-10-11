//
//  SearchScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 13.06.2025
//

import UIKit
import SnapKit

protocol SearchScreenViewProtocol: AnyObject {
    // MARK: - LOAD
    func applySnapshot(sections: [SearchScreenVC.Sections], itemsBySection: [SearchScreenVC.Sections: [SearchScreenVC.Items]])
    
    // MARK: - LOADING
    func showLoadingView()
    func hideLoadingView()
    
    // MARK: - ERROR
    func didRecieveError(_ errorStr: String)
}

final class SearchScreenVC: UIViewController {
    
    // MARK: - CONSTANTS
    fileprivate enum Constants { }
    
    // MARK: - SECTIONS
    enum Sections: Hashable {
        case searchBar
        case media
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
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            guard let self = self, let presenter = self.presenter else { return nil }
            let currentSection = presenter.visibleSections[sectionIndex]
            let edgeInsets: NSDirectionalEdgeInsets
            
            switch currentSection {
            case .media: edgeInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            default: edgeInsets = .zero
            }
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: item.layoutSize,
                subitems: [item]
            )
            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.contentInsets = edgeInsets
            return layoutSection
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
 
    // MARK: - ERROR
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

