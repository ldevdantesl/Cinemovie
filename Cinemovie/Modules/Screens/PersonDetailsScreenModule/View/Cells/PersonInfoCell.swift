//
//  PersonInfoCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.04.2025.
//

import UIKit
import SnapKit
import SDWebImage

final class PersonInfoCellViewModel: CellViewModelBaseClass {
    let personDetails: PersonDetails
    let showsBackButton: Bool
    let externalSources: ExternalSource?
    let didTapSource: ((String, SourceTypes) -> Void)?
    let didTapBackButton: (() -> Void)?
    
    init(personDetails: PersonDetails, externalSource: ExternalSource?, didTapBackButton: (() -> Void)?, didTapSource: ((String, SourceTypes) -> Void)?) {
        self.personDetails = personDetails
        self.externalSources = externalSource
        self.didTapBackButton = didTapBackButton
        self.showsBackButton = true
        self.didTapSource = didTapSource
        super.init(cellIdentifier: "PersonInfoCell")
    }
    
    init(personDetails: PersonDetails, externalSource: ExternalSource?, didTapSource: ((String, SourceTypes) -> Void)?) {
        self.personDetails = personDetails
        self.externalSources = externalSource
        self.didTapBackButton = nil
        self.showsBackButton = false
        self.didTapSource = didTapSource
        super.init(cellIdentifier: "PersonInfoCell")
    }
}

fileprivate final class SourceImageView: UIImageView {
    var sourceType: SourceTypes?
    var sourceID: String?
}

final class PersonInfoCell: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let backButtonImageName = "chevron.left"
        static let backButtonSize = 35.0
        static let defaultImageName = "person"
        static let defaultImagePointSize = 20.0
        static let imageBorderWidth = 0.5
        static let imageSize = (UIConstants.screenWidth - 20) * 0.3
        static let selfCornerRadius = 15.0
        static let itemSpacing = 20.0
        static let spacing = 5.0
        static let sourcesSpacing = 5.0
        static let vSpacing = 10.0
        static let hSpacing = 10.0
        static let sourceSize = 30.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: PersonInfoCellViewModel?
    private var avaImageTopConstraint: Constraint?
    private var secondStackTopConstraint: Constraint?
    
    // MARK: - VIEW PROPERTIES
    private let personAvaImageView: AsyncImageView = {
        let view = AsyncImageView()
        view.setBorder(width: Constants.imageBorderWidth, borderColor: CMColor.cmLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let personJobLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let personGenderLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .body, fontName: .avenirDemiBoldItalic)
        label.textColor = CMColor.cmSecondary
        label.numberOfLines = 1
        return label
    }()
    
    private let personNameLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .body, fontName: .avenirBold)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let personDOBLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenirMedium)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let personHometownLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .footnote, fontName: .avenirRegular)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let personSourcesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.sourcesSpacing
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }()
    
    private let firstPartStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.sourcesSpacing
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    private let secondPartStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.sourcesSpacing
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private let backButton: CMCircularButton = {
        let view = CMCircularButton()
        view.isHidden = true
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        firstPartStackView.arrangedSubviews.forEach { $0.removeFromSuperview(); firstPartStackView.removeArrangedSubview($0) }
        secondPartStackView.arrangedSubviews.forEach { $0.removeFromSuperview(); secondPartStackView.removeArrangedSubview($0) }
        personSourcesStackView.arrangedSubviews.forEach { $0.removeFromSuperview(); personSourcesStackView.removeArrangedSubview($0) }
        personAvaImageView.reset()
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
        self.personAvaImageView.makeCircular()
        self.contentView.layer.cornerRadius = Constants.selfCornerRadius
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: PersonInfoCellViewModel) {
        self.viewModel = viewModel
        self.personNameLabel.text = viewModel.personDetails.name
        
        if viewModel.showsBackButton {
            let vm = CMCircularButtonViewModel(
                systemName: Constants.backButtonImageName, backColor: CMColor.cmSecondaryBackground,
                foreColor: CMColor.cmAccent, didTapAction: viewModel.didTapBackButton
            )
            backButton.configure(viewModel: vm)
            backButton.isHidden = false
            
            backButton.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview().offset(Constants.vSpacing)
                $0.size.equalTo(Constants.backButtonSize)
            }

            avaImageTopConstraint?.update(offset: Constants.backButtonSize + Constants.vSpacing)
            secondStackTopConstraint?.update(offset: Constants.backButtonSize + Constants.vSpacing)
            self.layoutIfNeeded()
        }
        
        let vm = CMCircularButtonViewModel(
            systemName: Constants.backButtonImageName, backColor: CMColor.cmSecondaryBackground,
            foreColor: CMColor.cmAccent, didTapAction: viewModel.didTapBackButton
        )
        backButton.configure(viewModel: vm)
        
        secondPartStackView.addArrangedSubview(personNameLabel)
        if let birthday = viewModel.personDetails.birthday {
            self.personDOBLabel.text = CMDateFormatter.formatToNormalDate(dateString: birthday)
            secondPartStackView.addArrangedSubview(personDOBLabel)
            if let deathDay = viewModel.personDetails.deathday {
                self.personDOBLabel.text?.append(" - \(CMDateFormatter.formatToNormalDate(dateString: deathDay))")
            }
        }
        
        if let hometown = viewModel.personDetails.placeOfBirth {
            self.personHometownLabel.text = hometown
            secondPartStackView.addArrangedSubview(personHometownLabel)
        }
        
        addSources(externalSource: viewModel.externalSources)
        
        firstPartStackView.addArrangedSubview(personJobLabel)
        self.personJobLabel.text = viewModel.personDetails.knownForDepartment ?? "Unknown"
        firstPartStackView.addArrangedSubview(personGenderLabel)
        self.personGenderLabel.text = GenderHelper.identifyGender(gender: viewModel.personDetails.gender)
        
        let imagePath = viewModel.personDetails.profilePath
        personAvaImageView.setAsyncImage(
            path: imagePath, size: .w500,
            notFoundImageSystemName: Constants.defaultImageName,
            notFoundPointSize: Constants.defaultImagePointSize
        )
        
        self.invalidateIntrinsicContentSize()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.backgroundColor = CMColor.cmBackground
        contentView.addSubview(backButton)
        
        contentView.addSubview(personAvaImageView)
        personAvaImageView.snp.makeConstraints {
            avaImageTopConstraint = $0.top.equalToSuperview().offset(Constants.vSpacing).constraint
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
            $0.size.equalTo(Constants.imageSize)
        }
        
        contentView.addSubview(firstPartStackView)
        firstPartStackView.snp.makeConstraints {
            $0.top.equalTo(personAvaImageView.snp.bottom).offset(Constants.spacing)
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
            $0.trailing.equalTo(personAvaImageView.snp.trailing)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(secondPartStackView)
        secondPartStackView.snp.makeConstraints {
            secondStackTopConstraint = $0.top.equalToSuperview().offset(Constants.vSpacing).constraint
            $0.leading.equalTo(firstPartStackView.snp.trailing).offset(Constants.itemSpacing)
            $0.trailing.equalToSuperview().offset(-Constants.hSpacing)
            $0.bottom.equalTo(personAvaImageView.snp.bottom).inset(Constants.spacing)
        }
        
        contentView.addSubview(personSourcesStackView)
        personSourcesStackView.snp.makeConstraints {
            $0.leading.equalTo(secondPartStackView.snp.leading)
            $0.trailing.equalToSuperview().offset(-Constants.hSpacing)
            $0.centerY.equalTo(firstPartStackView.snp.centerY)
        }
    }
    
    private func addSources(externalSource: ExternalSource?) {
        let sourceMap: [(id: String?, type: SourceTypes)] = [
            (externalSource?.instagramID, .instagram),
            (externalSource?.facebookID, .facebook),
            (externalSource?.tiktokID, .tiktok),
            (externalSource?.wikidataID, .wikipedia),
            (externalSource?.imdbID, .imdb),
        ]

        sourceMap.forEach { item in
            if let id = item.id, !id.isEmpty {
                createSource(id: id, type: item.type)
            }
        }
        
        personSourcesStackView.addArrangedSubview(UIView())
    }
    
    private func createSource(id: String, type: SourceTypes) {
        let view = SourceImageView()
        view.image = UIImage(named: type.imageName)
        view.sourceType = type
        view.sourceID = id
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapSource)))
        personSourcesStackView.addArrangedSubview(view)
        view.snp.makeConstraints {
            $0.height.equalTo(Constants.sourceSize)
            $0.width.equalTo(Constants.sourceSize)
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapSource(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? SourceImageView, let type = view.sourceType,
              let id = view.sourceID else { return }

        viewModel?.didTapSource?(id, type)
    }
}
