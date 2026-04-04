//
//  SettingsLogOutCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.04.2026.
//

import UIKit
import SnapKit

final class SettingsLogOutCellViewModel: CellViewModelBaseClass {
    let didTap: (() -> Void)?
    
    init(didTap: (() -> Void)? = nil) {
        self.didTap = didTap
        super.init(cellIdentifier: SettingsLogOutCell.identifier)
    }
}

final class SettingsLogOutCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let cornerRadius = 15.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: SettingsLogOutCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let logOutButton: CMButton = {
        let vm = CMButtonViewModel(
            text: "Log Out", foreColor: .red,
            font: CMFont.font(size: .subtitle, fontName: .avenirBold),
            backColor: CMColor.cmSecondaryBackground
        )
        let button = CMButton(viewModel: vm)
        button.setCornerRadius(Constants.cornerRadius)
        return button
    }()
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(withVM vm: SettingsLogOutCellViewModel) {
        self.viewModel = vm
        logOutButton.setAction(action: vm.didTap)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(logOutButton)
        logOutButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}
