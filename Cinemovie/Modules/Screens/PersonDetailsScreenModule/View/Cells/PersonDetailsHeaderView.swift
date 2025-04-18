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
    let imagePath: String?
    let isBackButtonHidden: Bool
    let didTapAvaImage: (() -> Void)?
    let didTapBackButton: (() -> Void)?
}

final class PersonDetailsHeaderView: UICollectionViewCell {
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let backButtonImage = "chevron.left"
        static let backButtonSize = 35.0
        
        static let avaDefaultImageName = "person"
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
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAvaImage)))
        image.backgroundColor = CMColor.cmSecondaryBackground
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var backButton: CMCircularButton = {
        let button = CMCircularButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.avatarImageView.image = nil
        self.avatarImageView.contentMode = .scaleAspectFill
        self.backButton.isHidden = true
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: PersonDetailsHeaderViewModel) {
        self.viewModel = viewModel

        let vm = CMCircularButtonViewModel(
            systemName: Constants.backButtonImage, backColor: CMColor.cmSecondaryBackground,
            foreColor: CMColor.cmAccent, didTapAction: viewModel.didTapBackButton
        )
        backButton.configure(viewModel: vm)
        backButton.isHidden = !viewModel.isBackButtonHidden
        
        guard let url = URLHelper.getImageURL(with: viewModel.imagePath, size: .w780) else {
            avatarImageView.preferredSymbolConfiguration = .init(pointSize: Constants.avaImageSize * 0.6, weight: .bold)
            avatarImageView.contentMode = .center
            avatarImageView.image = UIImage(systemName: Constants.avaDefaultImageName)
            return
        }
        
        loadingIndicator.startAnimating()
        avatarImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
        }
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.vPadding)
            $0.leading.equalToSuperview()
            $0.size.equalTo(Constants.backButtonSize)
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
            $0.size.equalTo(Constants.avaImageSize)
        }
    }
    
    @objc private func didTapAvaImage() {
        viewModel?.didTapAvaImage?()
    }
}
