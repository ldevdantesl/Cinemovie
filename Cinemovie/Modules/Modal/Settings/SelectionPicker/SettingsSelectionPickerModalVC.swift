//
//  SettingsChooseRegion.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.04.2026.
//

import UIKit
import SnapKit

final class SettingsSelectionPickerModalVC: UIViewController {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 10.0
        static let vSpacing = 20.0
    }
    
    // MARK: - INJECTED
    private let viewModel: SettingsSelectionPickerViewModel
    
    // MARK: - PUBLIC PROPERTY
    var onDismiss: (() -> Void)?

    // MARK: - VIEW PROPERTIES
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.title
        label.font = CMFont.font(size: .custom(24), fontName: .avenirDemiBold)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = viewModel.searchPlaceholder
        sb.searchBarStyle = .minimal
        sb.delegate = self
        return sb
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.resignsFirstResponderOnScroll = true
        tv.register(SettingsModalSelectionCell.self, forCellReuseIdentifier: SettingsModalSelectionCell.identifier)
        return tv
    }()
    
    private let loadingView: CMSplashView = {
        let view = CMSplashView()
        view.hide()
        return view
    }()

    // MARK: - LIFECYCLE
    init(viewModel: SettingsSelectionPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.onDismiss?()
    }

    // MARK: - PRIVATE FUNC
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.vSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.spacing)
        }
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview()
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func loadData() {
        loadingView.show()
        Task {
            do {
                try await viewModel.loadData()
                await MainActor.run {
                    tableView.reloadData()
                    loadingView.hide()
                }
            } catch {
                await MainActor.run {
                    loadingView.hide()
                }
            }
        }
    }
}

extension SettingsSelectionPickerModalVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(by: searchText)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SettingsSelectionPickerModalVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.filteredItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsModalSelectionCell.identifier, for: indexPath)
        (cell as? SettingsModalSelectionCell)?.configure(withVM: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectItem(at: indexPath.row)
        tableView.reloadData()
    }
}
