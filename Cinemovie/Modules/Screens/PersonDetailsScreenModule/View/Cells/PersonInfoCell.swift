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
    let externalSources: ExternalSource
    let didTapSource: ((String, SourceTypes) -> Void)?
    let didTapBackButton: (() -> Void)?
    
    init(personDetails: PersonDetails, externalSource: ExternalSource, didTapBackButton: (() -> Void)?, didTapSource: ((String, SourceTypes) -> Void)?) {
        self.personDetails = personDetails
        self.externalSources = externalSource
        self.didTapBackButton = didTapBackButton
        self.didTapSource = didTapSource
        super.init(cellIdentifier: "PersonInfoCell")
    }
}

fileprivate final class SourceImageView: UIImageView {
    var sourceType: SourceTypes?
    var sourceID: String?
}

final class PersonInfoCell: ReusableCellBaseClass {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let backButtonImageName = "chevron.left"
        static let backButtonSize = 35.0
        static let defaultImageName = "person"
        static let defaultImagePointSize = 20.0
        static let imageBorderWidth = 0.5
        static let imageHeight = (UIConstants.screenWidth - 20) * 0.3
        
        static let spacing = 5.0
        static let sourcesSpacing = 5.0
        static let vSpacing = 5.0
        static let sourceSize = 30.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: PersonInfoCellViewModel?
    
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
        label.font = CMFont.font(size: .caption, fontName: .avenirMedium)
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
        personAvaImageView.image = nil
        personAvaImageView.contentMode = .scaleAspectFill
        personDOBLabel.text = nil
        personNameLabel.text = nil
        personHometownLabel.text = nil
        personGenderLabel.text = nil
        personJobLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.personAvaImageView.makeCircular()
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: PersonInfoCellViewModel) {
        self.viewModel = viewModel
        self.personNameLabel.text = viewModel.personDetails.name
        
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
        
        if let hometown = viewModel.personDetails.placeOfBirth{
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
        
        self.layoutIfNeeded()
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        contentView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(Constants.backButtonSize)
        }
        
        contentView.addSubview(personAvaImageView)
        personAvaImageView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(Constants.vSpacing)
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(personAvaImageView.snp.width)
        }
        
        contentView.addSubview(firstPartStackView)
        firstPartStackView.snp.makeConstraints {
            $0.top.equalTo(personAvaImageView.snp.bottom).offset(Constants.spacing)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(personAvaImageView.snp.trailing)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(secondPartStackView)
        secondPartStackView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(Constants.vSpacing)
            $0.leading.equalTo(firstPartStackView.snp.trailing).offset(20)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(personAvaImageView.snp.bottom).inset(Constants.vSpacing)
        }
        
        contentView.addSubview(personSourcesStackView)
        personSourcesStackView.snp.makeConstraints {
            $0.leading.equalTo(secondPartStackView.snp.leading)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(firstPartStackView.snp.centerY)
        }
    }
    
    private func addSources(externalSource: ExternalSource) {
        let sourceMap: [(id: String?, type: SourceTypes)] = [
            (externalSource.instagramID, .instagram),
            (externalSource.facebookID, .facebook),
            (externalSource.tiktokID, .tiktok),
            (externalSource.wikidataID, .wikipedia),
            (externalSource.imdbID, .imdb),
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
