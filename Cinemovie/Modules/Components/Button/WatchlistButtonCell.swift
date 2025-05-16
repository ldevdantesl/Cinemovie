//
//  CMMovieAddToWatchlistAndOverviewCVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.03.2025.
//

import UIKit
import SnapKit

final class WatchlistButtonCellViewModel: CellViewModelBaseClass {
    var isWatchlisted: Bool
    let didTapAction: ((Bool) -> Void)?
    let showsAddToListButton: Bool
    let didTapAddToList: (() -> Void)?
    
    init(isWatchlisted: Bool, showsAddToListButton: Bool, didTapAction: ((Bool) -> Void)?, didTapAddToList: (() -> Void)? = nil) {
        self.isWatchlisted = isWatchlisted
        self.showsAddToListButton = showsAddToListButton
        self.didTapAction = didTapAction
        self.didTapAddToList = didTapAddToList
        super.init(cellIdentifier: "WatchlistButtonCell")
    }
}

final class WatchlistButtonCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let imageName = "plus"
        static let cellHeight = 40.0
        static let cornerRadius = 15.0
        static let addedImageName = "checkmark"
        
        static let spacing = 5.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: WatchlistButtonCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let longButton: CMButton = {
        let button = CMButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addToListButton: CMButton = {
        let button = CMButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.spacing
        stack.distribution = .fill
        return stack
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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        layoutAttributes.frame.size.height = Constants.cellHeight
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        buttonStack.clear()
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: WatchlistButtonCellViewModel) {
        self.viewModel = viewModel
        let vm = CMButtonViewModel(
            text: !viewModel.isWatchlisted ? "Watchlist" : "In watchlist",
            foreColor: !viewModel.isWatchlisted ? CMColor.cmDivider : CMColor.cmLabel,
            font: CMFont.font(size: .body, fontName: .avenirBold),
            image: UIImage(systemName: !viewModel.isWatchlisted ?  Constants.imageName : Constants.addedImageName),
            backColor: !viewModel.isWatchlisted ? CMColor.cmLabel : CMColor.cmSuccess,
            cornerRadius: Constants.cornerRadius, didTapAction: self.didTapAction
        )
        longButton.configure(viewModel: vm)
        buttonStack.addArrangedSubview(longButton)
        
        if viewModel.showsAddToListButton {
            let addToListButtonVM =  CMButtonViewModel(
                text: "List", foreColor: CMColor.cmDivider,
                font: CMFont.font(size: .body, fontName: .avenirBold),
                image: UIImage(systemName: Constants.imageName),
                backColor: CMColor.cmLabel, cornerRadius: Constants.cornerRadius,
                didTapAction: viewModel.didTapAddToList
            )
            addToListButton.configure(viewModel: addToListButtonVM)
            buttonStack.addArrangedSubview(addToListButton)
        }
        
        self.layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(buttonStack)
        buttonStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - OBJC
    @objc private func didTapAction() {
        guard let viewModel = viewModel else { return }
        let vm = CMButtonViewModel(
            text: viewModel.isWatchlisted ? "Watchlist" : "In watchlist",
            foreColor: viewModel.isWatchlisted ? CMColor.cmDivider : CMColor.cmLabel,
            font: CMFont.font(size: .body, fontName: .avenirBold),
            image: UIImage(systemName: viewModel.isWatchlisted ?  Constants.imageName : Constants.addedImageName),
            backColor: viewModel.isWatchlisted ? CMColor.cmLabel : CMColor.cmSuccess,
            cornerRadius: Constants.cornerRadius, didTapAction: self.didTapAction
        )
        longButton.reconfigure(viewModel: vm)
        
        viewModel.isWatchlisted.toggle()
        viewModel.didTapAction?(viewModel.isWatchlisted)
    }
}
