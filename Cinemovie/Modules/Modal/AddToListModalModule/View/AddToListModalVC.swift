//
//  AddToListModalVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 15.05.2025
//

import UIKit
import SnapKit

protocol AddToListModalViewProtocol: AnyObject {
    func showLoadingView()
    func hideLoadingView(completion: (() -> Void)?)
    
    func didReceiveError(_ errorStr: String)
    func reloadData()
    
    // MARK: - PROPERTIES
    var loadingBox: CMLoadingBox? { get set }
}


final class AddToListModalVC: UIViewController {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 5.0
        static let hSpacing = 10.0
    }
    
    // MARK: - PROPERTIES
    var presenter: AddToListModalPresenterProtocol?
    var loadingBox: CMLoadingBox?
    
    // MARK: - VIEW PROPERTIES
    private let downloadingView = CMSplashView()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: UIConstants.screenWidth - 20, height: 50)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = CMColor.cmBackground
        view.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        view.register(cellClass: SupplementaryHeaderCell.self)
        view.register(cellClass: AddToListItemCell.self)
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
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
}

extension AddToListModalVC: AddToListModalViewProtocol {
    func showLoadingView() {
        downloadingView.show()
    }
    
    func hideLoadingView(completion: (() -> Void)?) {
        downloadingView.hide(completion: completion)
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    func didReceiveError(_ errorStr: String) {
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

extension AddToListModalVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.presenter?.listAndStatus.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SupplementaryHeaderCell.identifier, for: indexPath
            ) as? SupplementaryHeaderCell else { return UICollectionViewCell() }
            let vm = SupplementaryHeaderViewModel(title: "Lists", subtitle: "Add Item to the list")
            cell.configure(viewModel: vm)
            return cell
        } else {
            guard let presenter = self.presenter else { return UICollectionViewCell() }
            let list = presenter.listAndStatus[indexPath.item - 1].list
            let isAdded = presenter.listAndStatus[indexPath.item - 1].isInList
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AddToListItemCell.identifier, for: indexPath
            ) as? AddToListItemCell else { return UICollectionViewCell() }
            let vm = AddToListItemCellViewModel(userList: list, isAdded: isAdded, didTapAddToList: presenter.didTapAddToList)
            cell.configure(viewModel: vm)
            return cell
        }
    }
}
