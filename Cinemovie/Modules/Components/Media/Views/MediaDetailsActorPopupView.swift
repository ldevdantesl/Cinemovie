//
//  MovieDetailsActorPopupCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.03.2025.
//

import UIKit
import SnapKit
import SDWebImage

struct MediaDetailsActorPopupViewModel: PopUPViewModel {
    let actor: Cast
    let didTapActorDetails: ((String) -> Void)?
    let didTapClose: (() -> Void)?
}

final class MediaDetailsActorPopupView: PopUPView {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let buttonImageName = "person"
        static let buttonCornerRadius = 15.0
        static let buttonHeight = 40.0
        
        static let spacing = 5
        static let biggerSpacing = 10.0
        static let superSpacing = 15
        
        static let containerHeight = 270.0
        static let containerWidth = UIConstants.screenWidth - 80
        static let containerCornerRadius = 15.0
        
        static let imageSize = 70.0
        static let loadingIndicatorSize = 10.0
        static let avaSystemImageSize = 40.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: MediaDetailsActorPopupViewModel
    
    // MARK: - VIEW PROPERTIES
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = CMColor.cmLabel
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var actorImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = CMColor.cmSecondaryBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var departmentLabel: UILabel = {
        let view = UILabel()
        view.text = viewModel.actor.knownForDepartment
        view.font = CMFont.font(size: .footnote, fontName: .avenirDemiBold)
        view.textColor = CMColor.cmSecondary
        view.numberOfLines = 1
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var actorNameLabel: UILabel = {
        let view = UILabel()
        view.text = "Name:  " + viewModel.actor.name
        view.font = CMFont.font(size: .caption, fontName: .avenirBold)
        view.textColor = CMColor.cmLabel
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var actorCharacterLabel: UILabel = {
        let view = UILabel()
        if let character = viewModel.actor.character, !character.isEmpty {
            view.text = "Role:  " + character
        }
        view.font = CMFont.font(size: .caption, fontName: .avenirBold)
        view.textColor = CMColor.cmLabel
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var actorDetailsButton: CMButton = {
        let vm = CMButtonViewModel(
            text: "Additional Details", foreColor: .cmLabel,
            font: CMFont.font(size: .body, fontName: .avenirDemiBold), image: nil,
            backColor: CMColor.cmSuccess, cornerRadius: Constants.buttonCornerRadius
        ) { [weak self] in
            guard let self = self else { return }
            self.viewModel.didTapActorDetails?(viewModel.actor.creditID)
        }
        
        let button = CMButton(viewModel: vm)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var actorGenderLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender:  " + (viewModel.actor.gender == 1 ? "Female" : "Male")
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .caption, fontName: .avenirBold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = CMColor.cmSecondaryBackground
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [actorNameLabel, actorCharacterLabel, actorGenderLabel, UIView()])
        stack.axis = .vertical
        stack.spacing = Constants.biggerSpacing
        stack.alignment = .fill
        return stack
    }()
    
    // MARK: - LIFECYCLE
    init(viewModel: MediaDetailsActorPopupViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
        setupUI()
        
        guard let url = URLHelper.getImageURL(with: viewModel.actor.profilePath, size: .w342) else {
            self.actorImageView.contentMode = .center
            self.actorImageView.preferredSymbolConfiguration = .init(pointSize: Constants.avaSystemImageSize, weight: .bold)
            self.actorImageView.image = UIImage(systemName: Constants.buttonImageName)
            return
        }
        
        loadingIndicator.startAnimating()
        self.actorImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        actorImageView.layer.cornerRadius = Constants.imageSize / 2
        self.containerView.layer.cornerRadius = Constants.containerCornerRadius
    }
    
    deinit {
        print("Actor popup removed")
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(Constants.containerHeight)
            $0.width.equalTo(Constants.containerWidth)
        }
        
        actorImageView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(Constants.loadingIndicatorSize)
        }
        
        containerView.addSubview(actorImageView)
        actorImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.superSpacing)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(Constants.imageSize)
        }
        
        containerView.addSubview(departmentLabel)
        departmentLabel.snp.makeConstraints {
            $0.top.equalTo(actorImageView.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.biggerSpacing)
        }
        
        containerView.addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.top.equalTo(departmentLabel.snp.bottom).offset(Constants.biggerSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.biggerSpacing)
        }
        
        containerView.addSubview(actorDetailsButton)
        actorDetailsButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-Constants.biggerSpacing)
            $0.horizontalEdges.equalToSuperview().inset(Constants.biggerSpacing)
            $0.height.equalTo(Constants.buttonHeight)
        }
    }
}
