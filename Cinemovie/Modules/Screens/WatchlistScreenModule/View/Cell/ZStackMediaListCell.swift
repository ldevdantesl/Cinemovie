//
//  ZStackMediaList.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.04.2025.
//

import UIKit
import SnapKit

final class ZStackMediaListCellViewModel: CellViewModelBaseClass {
    let media: [Media]
    let title: String
    let subtitle: String?
    let didTapList: ((UserListTypes) -> Void)?
    let listType: UserListTypes?
    
    init(media: [Media], title: String, subtitle: String? = nil) {
        self.media = media
        self.title = title
        self.subtitle = subtitle
        self.didTapList = nil
        self.listType = nil
        super.init(cellIdentifier: "ZStackMediaListCell")
    }
    
    init(media: [Media], title: String, subtitle: String? = nil, listType: UserListTypes?, didTapList: ((UserListTypes) -> Void)?) {
        self.media = media
        self.title = title
        self.subtitle = subtitle
        self.didTapList = didTapList
        self.listType = listType
        super.init(cellIdentifier: "ZStackMediaListCell")
    }
}

final class ZStackMediaListCell: ReusableCellBaseClass {
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing = 5.0
        static let vSpacing = 10.0
        static let posterBorderWidth = 0.5
        static let posterCornerRadius = 10.0
        static let notFoundImageName = "questionmark"
        static let notFoundPointSize = 20.0
        static let plusImageName = "plus"
        static let plusPointSize = 30.0
        static let horizontalInset = 30.0
        static let posterHeight = UIConstants.screenHeight * 0.3
    }
    
    // MARK: - PROPERTIES
    private var viewModel: ZStackMediaListCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private lazy var posterStackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .caption, fontName: .avenirMediumItalic)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let plusPosterView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = CMColor.cmSecondaryBackground
        view.contentMode = .center
        view.clipsToBounds = true
        view.image = UIImage(systemName: Constants.plusImageName)
        view.preferredSymbolConfiguration = .init(pointSize: Constants.plusPointSize, weight: .bold)
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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let height = contentView.systemLayoutSizeFitting(
            CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel
        ).height
        layoutAttributes.frame.size.height = height
        return layoutAttributes
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.plusPosterView.layer.cornerRadius = Constants.posterCornerRadius
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: ZStackMediaListCellViewModel) {
        self.viewModel = viewModel
        self.stackTitleLabel.text = viewModel.title
        self.stackSubtitleLabel.text = viewModel.subtitle
        self.stackPosters(items: viewModel.media.reversed())
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAction)))
        contentView.addSubview(posterStackView)
        posterStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(posterStackView.snp.width).multipliedBy(1.5).priority(.high)
        }

        contentView.addSubview(stackTitleLabel)
        stackTitleLabel.snp.makeConstraints {
            $0.top.equalTo(posterStackView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.addSubview(stackSubtitleLabel)
        stackSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(stackTitleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func stackPosters(items: [Media]) {
        posterStackView.subviews.forEach { $0.removeFromSuperview() }
        guard !items.isEmpty else {
            posterStackView.addSubview(plusPosterView)
            plusPosterView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(0.8)
                $0.height.equalTo(plusPosterView.snp.width).multipliedBy(1.5)
            }
            return
        }

        let postersToShow = items.prefix(3)
        let baseOffset = 15.0
        let count = postersToShow.count
        let totalOffset = Double(count - 1) * baseOffset

        for (index, item) in postersToShow.enumerated().reversed() {
            let imageView = AsyncImageView()
            imageView.setBorder(width: Constants.posterBorderWidth, borderColor: CMColor.cmLabel)
            imageView.setCornerRadius(Constants.posterCornerRadius)
            imageView.setAsyncImage(
                path: item.posterPath, size: .w1280,
                notFoundImageSystemName: Constants.notFoundImageName,
                notFoundPointSize: Constants.notFoundPointSize
            )
            posterStackView.addSubview(imageView)
            let centerOffset = -(Double(index) * baseOffset - totalOffset / 2)

            imageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.centerX.equalToSuperview().offset(centerOffset)
                $0.width.equalToSuperview().multipliedBy(0.8)
                $0.height.equalTo(imageView.snp.width).multipliedBy(1.5)
            }
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapAction() {
        guard let listType = viewModel?.listType else { return }
        viewModel?.didTapList?(listType)
    }
}
