//
//  PersonDetailsHeaderView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 20.03.2025.
//

import UIKit
import SnapKit
import SDWebImage

struct PersonDetailsHeaderViewModel: PersonDetailsCellViewModel {
    let identifier: String = "PersonDetailsHeaderView"
    let imagePath: String
    let didTapAvaImage: (() -> Void)?
    let didTapBackButton: (() -> Void)?
}

final class PersonDetailsHeaderView: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let backButtonImage = "chevron.left"
        static let backButtonSize = 35.0
        
        static let avaImageSize = 100.0
        static let loadingIndicatorSize = 20.0
        
        static let vPadding = 10.0
        static let hPadding = 10.0
        static let bigPadding = 20.0
    }
    
    // MARK: - STATIC
    static let identifier = "PersonDetailsHeaderView"
    
    // MARK: - PROPERTIES
    private var viewModel: PersonDetailsHeaderViewModel?
    
    // MARK: - VIEW PROPERTIES
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAvaImage)))
        return image
    }()
    
    private lazy var backButton: CMCircularButton = {
        let button = CMCircularButton(
            systemName: Constants.backButtonImage, size: Constants.backButtonSize,
            backColor: CMColor.cmSecondaryBackground, foreColor: CMColor.cmAccent,
            target: self, action: #selector(didTapBackButton)
        )
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.avatarImageView.layer.cornerRadius = Constants.avaImageSize / 2
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: PersonDetailsHeaderViewModel) {
        self.viewModel = viewModel
        if let url = URLHelper.getImageURL(with: viewModel.imagePath, size: .w780) {
            loadingIndicator.startAnimating()
            avatarImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
                guard let self = self else { return }
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.vPadding)
            $0.leading.equalToSuperview()
        }
        
        avatarImageView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(Constants.loadingIndicatorSize)
        }
        
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(Constants.bigPadding)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(Constants.avaImageSize)
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapBackButton() {
        viewModel?.didTapBackButton?()
    }
    
    @objc private func didTapAvaImage() {
        viewModel?.didTapAvaImage?()
    }
}
