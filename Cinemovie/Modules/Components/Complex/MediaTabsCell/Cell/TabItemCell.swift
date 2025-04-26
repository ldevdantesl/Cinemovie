//
//  MediaTabItemCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.03.2025.
//

import UIKit
import SnapKit

final class TabItemCellViewModel: CellViewModelBaseClass {
    let text: String
    let isSelected: Bool
    let isCapsuled: Bool
    
    init(text: String, isSelected: Bool, isCapsuled: Bool) {
        self.text = text
        self.isSelected = isSelected
        self.isCapsuled = isCapsuled
        super.init(cellIdentifier: "TabItemCell")
    }
}

final class TabItemCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let topBarHeight = 5.0
        static let spacing = 5.0
        static let hSpacing = 10.0
        static let aniDuration = 0.3
        static let selfCornerRadius = 15.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: TabItemCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = CMColor.cmSuccess
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = (self.viewModel?.isCapsuled ?? false) ? Constants.selfCornerRadius : 0
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: TabItemCellViewModel) {
        self.viewModel = viewModel
        self.titleLabel.text = viewModel.text
        
        UIView.animate(withDuration: Constants.aniDuration) { [weak self] in
            guard let self = self else { return }
            self.titleLabel.textColor = viewModel.isSelected ? CMColor.cmLabel : CMColor.cmSecondary
            if viewModel.isCapsuled {
                self.contentView.backgroundColor = !viewModel.isSelected ? CMColor.cmSecondaryBackground: CMColor.cmSystem
                self.titleLabel.snp.remakeConstraints {
                    $0.verticalEdges.equalToSuperview().inset(Constants.spacing)
                    $0.horizontalEdges.equalToSuperview().inset(Constants.hSpacing)
                }
            } else {
                self.topBarView.alpha = !viewModel.isSelected ? 0 : 1
            }
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(topBarView)
        topBarView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constants.topBarHeight)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
