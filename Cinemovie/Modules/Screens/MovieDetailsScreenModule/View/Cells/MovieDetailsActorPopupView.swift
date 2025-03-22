//
//  MovieDetailsActorPopupCell.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.03.2025.
//

import UIKit
import SnapKit
import SDWebImage

struct MovieDetailsActorPopupViewModel {
    let actor: Cast
    let didTapActorDetails: ((String) -> Void)?
}

final class MovieDetailsActorPopupView: UIView {
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
    private var viewModel: MovieDetailsActorPopupViewModel?
    
    // MARK: - VIEW PROPERTIES
    private lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapClose)))
        return view
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = CMColor.cmLabel
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let actorImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = CMColor.cmSecondaryBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let departmentLabel: UILabel = {
        let view = UILabel()
        view.font = CMFont.font(size: .footnote, fontName: .avenirDemiBold)
        view.textColor = CMColor.cmSecondary
        view.numberOfLines = 1
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let actorNameLabel: UILabel = {
        let view = UILabel()
        view.font = CMFont.font(size: .caption, fontName: .avenirBold)
        view.textColor = CMColor.cmLabel
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let actorCharacterLabel: UILabel = {
        let view = UILabel()
        view.font = CMFont.font(size: .caption, fontName: .avenirBold)
        view.textColor = CMColor.cmLabel
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var actorDetailsButton: CMButton = {
        let button = CMButton(
            text: "Additional Details", foreColor: .cmLabel,
            textFont: CMFont.font(size: .body, fontName: .avenirDemiBold), image: nil,
            backColor: CMColor.cmSuccess, cornerRadius: Constants.buttonCornerRadius
        )
        button.setAction(target: self, action: #selector(didTapDetails))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let actorGenderLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .caption, fontName: .avenirBold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
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
        actorImageView.layer.cornerRadius = Constants.imageSize / 2
        self.containerView.layer.cornerRadius = Constants.containerCornerRadius
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: MovieDetailsActorPopupViewModel) {
        self.viewModel = viewModel
        self.actorNameLabel.text = "Name:  " + viewModel.actor.name
        self.actorGenderLabel.text = "Gender:  " + (viewModel.actor.gender == 1 ? "Female" : "Male")
        self.departmentLabel.text = viewModel.actor.knownForDepartment
        if let character = viewModel.actor.character, !character.isEmpty {
            self.actorCharacterLabel.text =  "Role:  " + character
        }
        
        if let url = URLHelper.getImageURL(with: viewModel.actor.profilePath, size: .w342) {
            loadingIndicator.startAnimating()
            self.actorImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
                guard let self = self else { return }
                self.loadingIndicator.stopAnimating()
            }
        } else {
            actorImageView.contentMode = .center
            actorImageView.preferredSymbolConfiguration = .init(pointSize: Constants.avaSystemImageSize, weight: .bold)
            actorImageView.image = UIImage(systemName: Constants.buttonImageName)
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
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
    
    // MARK: - OBJC FUNC
    @objc private func didTapClose() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) { [weak self] in
            guard let self = self else { return }
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).concatenating(CGAffineTransform(translationX: 0, y: 30))
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.removeFromSuperview()
        }
    }
    
    @objc private func didTapDetails() {
        guard let creditID = viewModel?.actor.creditID else { return }
        viewModel?.didTapActorDetails?(creditID)
    }
}
