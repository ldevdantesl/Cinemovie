//
//  PersonDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 20.03.2025
//

import UIKit
import SnapKit
import SDWebImage

protocol PersonDetailsScreenViewProtocol: AnyObject {
    func applySnapshot(sections: [PersonDetailsScreenVC.Sections], itemsBySection: [PersonDetailsScreenVC.Sections : [PersonDetailsScreenVC.Items]])
    func didRecieveError(_ errorStr: String)
    
    var downloadingView: CMSplashView { get }
}

final class PersonDetailsScreenVC: UIViewController {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let collectionViewSpacing = 10.0
        static let aniDuration = 1.0
        static let defaultCellHeight = 100.0
    }
    
    // MARK: - SECTIONS
    enum Sections: Hashable {
        case images
        case info
        case overview
        case movies
        case tvSeries
        case unavailable
    }
    
    enum Items: Hashable {
        case imageCell(PersonImagesCellViewModel)
        case infoVM(PersonInfoCellViewModel)
        case overviewVM(OverviewCellViewModel)
        case mediaListVM(MediaListCellViewModel)
        case unavailableVM(UnavailableInfoCellViewModel)
    }
    
    // MARK: - VIPER
    var presenter: PersonDetailsScreenPresenterProtocol?
    let downloadingView: CMSplashView = {
        let splash = CMSplashView(frame: .zero, showsLoadingLabel: true)
        splash.translatesAutoresizingMaskIntoConstraints = false
        return splash
    }()
    
    // MARK: - VIEW PROPERTIES
    private lazy var collectionView: DiffableCollectionView = {
        let cv = DiffableCollectionView<Sections, Items>(layout: createLayout(), showsTopBlur: true)
        cv.layer.zPosition = 0
        cv.register(cellClass: PersonImagesCell.self)
        cv.register(cellClass: PersonInfoCell.self)
        cv.register(cellClass: MediaListCell.self)
        cv.register(cellClass: OverviewCell.self)
        cv.register(cellClass: UnavailableInfoCell.self)
        cv.delegate = self
        cv.backgroundColor = CMColor.cmBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupUI()
        configureDataSource()
        downloadingView.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SDImageCache.shared.clearMemory()
    }
    
    deinit {
        print("Person Details Screen deinit")
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
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            guard let self = self, let presenter = self.presenter else { return nil }
            
            
            let detailsSection = presenter.visibleSections[sectionIndex]
            let edgeInsets: NSDirectionalEdgeInsets
            let containsImages = presenter.visibleSections.contains(.images)
            
            switch detailsSection {
            case .images: edgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            case .info: edgeInsets = .init(top: containsImages ? 10 : UIConstants.topInset, leading: 0, bottom: 0, trailing: 0)
            default: edgeInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            }
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200)))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: item.layoutSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = edgeInsets
            return section
        }
    }
    
    private func configureDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .imageCell(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? PersonImagesCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .infoVM(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? PersonInfoCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .overviewVM(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? OverviewCell
                cell?.configure(with: vm)
                return cell
                
            case .mediaListVM(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? MediaListCell
                cell?.configure(viewModel: vm)
                return cell
                
            case .unavailableVM(let vm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellIdentifier, for: indexPath) as? UnavailableInfoCell
                cell?.configure(viewModel: vm)
                return cell
            }
        }
    }
}

extension PersonDetailsScreenVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.showBlur(scrollView)
    }
}

extension PersonDetailsScreenVC: PersonDetailsScreenViewProtocol {
    func didRecieveError(_ errorStr: String) {
        let alert = UIAlertController(
            title: "Oops..",
            message: errorStr,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            presenter?.didTapBackButton()
        }

        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func applySnapshot(sections: [Sections], itemsBySection: [Sections : [Items]]) {
        DispatchQueue.main.async {
            self.collectionView.applySnapshot(sections: sections, itemsBySection: itemsBySection)
        }
    }
}
