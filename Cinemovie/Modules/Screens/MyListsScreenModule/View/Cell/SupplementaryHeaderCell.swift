//
//  SupplementaryHeaderCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 10.05.2025.
//

import UIKit
import SnapKit

final class SupplementaryHeaderViewModel: CellViewModelBaseClass {
    let title: String
    let subtitle: String?
    let showsTopShadow: Bool
    let leftButtonImageName: String?
    let leftButtonTintColor: UIColor?
    let didTapLeftButton: (() -> Void)?
    let rightButtonImageName: String?
    let rightButtonTintColor: UIColor?
    let didTapRightButton: (() -> Void)?
    
    init(title: String, subtitle: String?, showsTopShadow: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.showsTopShadow = showsTopShadow
        self.rightButtonImageName = nil
        self.rightButtonTintColor = nil
        self.didTapRightButton = nil
        
        self.leftButtonImageName = nil
        self.leftButtonTintColor = nil
        self.didTapLeftButton = nil
        super.init(cellIdentifier: "SupplementaryHeaderCell")
    }
    
    init(
        title: String, subtitle: String?,
        showsTopShadow: Bool = false,
        buttonImageName: String,
        buttonTintColor: UIColor,
        didTapButton: (() -> Void)?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.showsTopShadow = showsTopShadow
        self.didTapRightButton = didTapButton
        self.rightButtonImageName = buttonImageName
        self.rightButtonTintColor = buttonTintColor
        
        self.didTapLeftButton = nil
        self.leftButtonImageName = nil
        self.leftButtonTintColor = nil
        super.init(cellIdentifier: "SupplementaryHeaderCell")
    }
    
    init(
        title: String, subtitle: String?,
        showsTopShadow: Bool = false,
        rightButtonImageName: String? = nil,
        rightButtonTintColor: UIColor? = nil,
        didTapRightButton: (() -> Void)? = nil,
        leftButtonImageName: String? = nil,
        leftButtonTintColor: UIColor? = nil,
        didTapLeftButton: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.showsTopShadow = showsTopShadow
        self.didTapRightButton = didTapRightButton
        self.rightButtonImageName = rightButtonImageName
        self.rightButtonTintColor = rightButtonTintColor
        
        self.didTapLeftButton = didTapLeftButton
        self.leftButtonImageName = leftButtonImageName
        self.leftButtonTintColor = leftButtonTintColor
        super.init(cellIdentifier: "SupplementaryHeaderCell")
    }
}

final class SupplementaryHeaderCell: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let buttonSize = 30.0
        static let spacing = 5.0
        static let vSpacing = 15.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: SupplementaryHeaderViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        view.contentView.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let shadowLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.black.cgColor,
            UIColor.clear.cgColor
        ]
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return layer
    }()
    
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
    
    private let headerRightButton: CMCircularButton = {
        let button = CMCircularButton()
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let headerLeftButton: CMCircularButton = {
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
        self.headerLeftButton.isHidden = true
        self.headerLeftButton.clear()
        self.headerRightButton.isHidden = true
        self.blurView.isHidden = true
        self.headerRightButton.clear()
    }
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowLayer.frame = blurView.bounds
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: SupplementaryHeaderViewModel) {
        self.viewModel = viewModel
        self.headerTitleLabel.text = viewModel.title
        self.headerSubtitleLabel.text = viewModel.subtitle
        self.blurView.isHidden = !viewModel.showsTopShadow
        
        if let rightButtonImageName = viewModel.rightButtonImageName {
            let vm = CMCircularButtonViewModel(
                systemName: rightButtonImageName, backColor: .clear,
                foreColor: viewModel.rightButtonTintColor ?? CMColor.cmLabel,
                imageSizeByRespectingOuterCircle: 0.9,
                didTapAction: viewModel.didTapRightButton
            )
            headerRightButton.configure(viewModel: vm)
            headerRightButton.isHidden = false
        }
        
        if let leftButtonImageName = viewModel.leftButtonImageName {
            let vm = CMCircularButtonViewModel(
                systemName: leftButtonImageName, backColor: .clear,
                foreColor: viewModel.leftButtonTintColor ?? CMColor.cmLabel,
                imageSizeByRespectingOuterCircle: 0.9,
                didTapAction: viewModel.didTapLeftButton
            )
            headerLeftButton.configure(viewModel: vm)
            headerLeftButton.isHidden = false
            
            headerLeftButton.snp.remakeConstraints {
                $0.leading.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.size.equalTo(Constants.buttonSize)
            }
            
            headerTitleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalTo(headerLeftButton.snp.trailing).offset(Constants.spacing)
            }
            
            headerSubtitleLabel.snp.remakeConstraints {
                $0.top.equalTo(headerTitleLabel.snp.bottom)
                $0.leading.equalTo(headerLeftButton.snp.trailing).offset(Constants.spacing)
                $0.bottom.equalToSuperview().offset(-Constants.spacing)
            }
        }
        
        layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        blurView.contentView.layer.insertSublayer(shadowLayer, at: 0)
        contentView.addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(headerLeftButton)
        contentView.addSubview(headerTitleLabel)
        headerTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        contentView.addSubview(headerSubtitleLabel)
        headerSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(headerTitleLabel.snp.bottom)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-Constants.spacing)
        }
        
        contentView.addSubview(headerRightButton)
        headerRightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(Constants.buttonSize)
        }
    }
}
