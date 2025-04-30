//
//  UnavailableInfoCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 20.04.2025.
//

import UIKit
import SnapKit

final class UnavailableInfoCellViewModel: CellViewModelBaseClass {
    let title: String
    let subtitle: String?
    let image: UIImage?
    
    init(title: String, subtitle: String? = nil, image: UIImage?) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        super.init(cellIdentifier: "UnavailableInfoCell")
    }
}

final class UnavailableInfoCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 5.0
        static let imageSize = (UIConstants.screenWidth - 20) * 0.3
    }
    
    // MARK: - PROPERTIES
    private var viewModel: UnavailableInfoCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let unavailableImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = CMColor.cmSystem
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let unavailableTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let unavailableSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenirMedium)
        label.textColor = CMColor.cmSecondary
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    public func configure(viewModel: UnavailableInfoCellViewModel) {
        self.viewModel = viewModel
        self.unavailableImageView.image = viewModel.image
        self.unavailableImageView.preferredSymbolConfiguration = .init(weight: .bold)
        self.unavailableTitleLabel.text = viewModel.title
        self.unavailableSubtitleLabel.text = viewModel.subtitle
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.backgroundColor = CMColor.cmBackground
        
        contentView.addSubview(unavailableImageView)
        unavailableImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.lessThanOrEqualTo(unavailableImageView.snp.width)
        }
        
        contentView.addSubview(unavailableTitleLabel)
        unavailableTitleLabel.snp.makeConstraints {
            $0.top.equalTo(unavailableImageView.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.addSubview(unavailableSubtitleLabel)
        unavailableSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(unavailableTitleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
