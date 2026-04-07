//
//  SettingsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit
import SnapKit

protocol SettingsScreenViewProtocol: AnyObject {
    func applySnapshot(sections: [SettingsScreenVC.Sections], items: [SettingsScreenVC.Sections : [SettingsScreenVC.Items]])
    func showLoading()
    func hideLoading()
    func reapplySnapshot()
    func didReceiveError(_ errorStr: String)
}

final class SettingsScreenVC: UIViewController {
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let buttonCornerRadius = 15.0
    }
    
    // MARK: - COMPOSITIONAL LAYOUT
    enum Sections: Hashable {
        case header
        case account
        case body
        case footer
    }
    
    enum Items: Hashable {
        case account(SettingsAccountCellViewModel)
        case header
        case logOut(SettingsLogOutCellViewModel)
        case preferences(SettingsPreferencesCellViewModel)
        case content(SettingsContentCellViewModel)
        case about(SettingsAboutCellViewModel)
        case footer
    }
    
    // MARK: - VIPER
    var presenter: SettingsScreenPresenterProtocol?
    
    // MARK: - PROPERTIES
    private var sectionStore: CMDiffableSectionStore<Sections> = .init()
    
    // MARK: - VIEW PROPERTIES
    private lazy var collectionView: DiffableCollectionView = {
        let layout = SettingsLayoutFactory.make(sectionStore: sectionStore)
        let cv = DiffableCollectionView<Sections, Items>(layout: layout, ignoresTopSafeArea: false)
        cv.register(cellClass: SettingsHeaderCell.self)
        cv.register(cellClass: SettingsAccountCell.self)
        cv.register(cellClass: SettingsLogOutCell.self)
        cv.register(cellClass: SettingsContentCell.self)
        cv.register(cellClass: SettingsAboutCell.self)
        cv.register(cellClass: SettingsFooterCell.self)
        cv.register(cellClass: SettingsPreferencesCell.self)
        cv.backgroundColor = CMColor.cmBackground
        return cv
    }()
    
    private let loadingView: CMSplashView = {
        let view = CMSplashView()
        view.hide()
        return view
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        setupUI()
        presenter?.viewDidLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.barTintColor = CMColor.cmBackground
        tabBarController?.tabBar.isTranslucent = false
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .account(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath)
                (cell as? SettingsAccountCell)?.configure(withVM: vm)
                return cell
                
            case .logOut(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath)
                (cell as? SettingsLogOutCell)?.configure(withVM: vm)
                return cell
                
            case .preferences(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath)
                (cell as? SettingsPreferencesCell)?.configure(withVM: vm)
                return cell
                
            case .content(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath)
                (cell as? SettingsContentCell)?.configure(withVM: vm)
                return cell
                
            case .about(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath)
                (cell as? SettingsAboutCell)?.configure(withVM: vm)
                return cell
                
            case .header:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsHeaderCell.identifier, for: indexPath)
                return cell
                
            case .footer:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsFooterCell.identifier, for: indexPath)
                return cell
            }
        }
    }
}

extension SettingsScreenVC: SettingsScreenViewProtocol {
    func applySnapshot(sections: [Sections], items: [Sections : [Items]]) {
        sectionStore.update(sections)
        collectionView.applySnapshot(sections: sections, itemsBySection: items)
    }
    
    func showLoading() {
        loadingView.show()
    }
    
    func hideLoading() {
        loadingView.hide()
    }
    
    func didReceiveError(_ errorStr: String) {
        let alert = UIAlertController(
            title: "Oops...",
            message: errorStr,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func reapplySnapshot() {
        self.presenter?.reapplySnapshot()
    }
}
