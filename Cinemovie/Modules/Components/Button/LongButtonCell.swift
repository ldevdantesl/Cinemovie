//
//  CMMovieAddToWatchlistAndOverviewCVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.03.2025.
//

import UIKit
import SnapKit

final class LongButtonCellViewModel: CellViewModelBaseClass {
    let text: String
    let imageSystemName: String?
    let foreColor: UIColor
    let backColor: UIColor
    let height: CGFloat
    let cornerRadius: CGFloat
    let action: (() -> Void)?
    
    init(
        text: String, imageSystemName: String?, foreColor: UIColor = CMColor.cmDivider,
        backColor: UIColor = CMColor.cmLabel, height: CGFloat = 40.0, cornerRadius: CGFloat = 15.0,
        action: (() -> Void)?
    ) {
        self.text = text
        self.imageSystemName = imageSystemName
        self.foreColor = foreColor
        self.backColor = backColor
        self.height = height
        self.cornerRadius = cornerRadius
        self.action = action
        super.init(cellIdentifier: "LongButtonCell")
    }
}

final class LongButtonCell: ReusableCellBaseClass {
    // MARK: - PROPERTIES
    private var viewModel: LongButtonCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let longButton: CMButton = {
        let button = CMButton()
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        layoutAttributes.frame.size.height = viewModel?.height ?? 40.0
        return layoutAttributes
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: LongButtonCellViewModel) {
        self.viewModel = viewModel
        let vm = CMButtonViewModel(
            text: viewModel.text, foreColor: viewModel.foreColor,
            font: CMFont.font(size: .body, fontName: .avenirBold),
            image: viewModel.imageSystemName != nil ? UIImage(systemName: viewModel.imageSystemName!) : nil,
            backColor: viewModel.backColor, cornerRadius: viewModel.cornerRadius,
            didTapAction: viewModel.action
        )
        longButton.configure(viewModel: vm)
        
        self.layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(longButton)
        longButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
