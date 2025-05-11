//
//  SupplementaryHeaderCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 10.05.2025.
//

import UIKit
import SnapKit

struct SupplementaryHeaderViewModel {
    let title: String
    let subtitle: String?
    let cellIdentifier: String
    let buttonImageName: String?
    let buttonTintColor: UIColor?
    let didTapButton: (() -> Void)?
    
    init(title: String, subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
        self.buttonImageName = nil
        self.didTapButton = nil
        self.buttonTintColor = nil
        self.cellIdentifier = "SupplementaryHeaderCell"
    }
    
    init(title: String, subtitle: String?, buttonImageName: String, buttonTintColor: UIColor, didTapButton: (() -> Void)?) {
        self.title = title
        self.subtitle = subtitle
        self.didTapButton = didTapButton
        self.buttonImageName = buttonImageName
        self.buttonTintColor = buttonTintColor
        self.cellIdentifier = "SupplementaryHeaderCell"
    }
}

final class SupplementaryHeaderCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let buttonSize = 30.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: SupplementaryHeaderViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let headerSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmSublabel
        label.font = CMFont.font(size: .caption, fontName: .avenirRegular)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let headerButton: CMCircularButton = {
        let button = CMCircularButton()
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
        self.headerTitleLabel.text = nil
        self.headerSubtitleLabel.text = nil
        self.headerButton.isHidden = true
        self.headerButton.clear()
    }
    
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
    public func configure(viewModel: SupplementaryHeaderViewModel) {
        self.viewModel = viewModel
        self.headerTitleLabel.text = viewModel.title
        self.headerSubtitleLabel.text = viewModel.subtitle
        
        guard let buttonImageName = viewModel.buttonImageName else { return }
        let vm = CMCircularButtonViewModel(
            systemName: buttonImageName, backColor: .clear,
            foreColor: viewModel.buttonTintColor ?? CMColor.cmLabel,
            imageSizeByRespectingOuterCircle: 0.9,
            didTapAction: viewModel.didTapButton
        )
        headerButton.configure(viewModel: vm)
        headerButton.isHidden = false
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(headerTitleLabel)
        headerTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        contentView.addSubview(headerButton)
        headerButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerY.equalToSuperview().priority(.low)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(Constants.buttonSize)
        }
        
        contentView.addSubview(headerSubtitleLabel)
        headerSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(headerTitleLabel.snp.bottom)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
