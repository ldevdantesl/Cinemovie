//
//  CMMovieSubDetailsView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.03.2025.
//

import UIKit
import SnapKit

final class MovieDetailsSubDetailsCellViewModel: CellViewModelBaseClass {
    let year: String
    let released: Bool
    let duration: String
    let imdbPath: String?
    let didTapIMDB: (() -> Void)?
    let didTapSubDetails: ((UIView, String) -> Void)?
    
    init(
        year: String, released: Bool, duration: String,
        imdbPath: String?, didTapIMDB: (() -> Void)? = nil,
        didTapSubDetails: ((UIView, String) -> Void)? = nil
    ) {
        self.year = year
        self.released = released
        self.duration = duration
        self.imdbPath = imdbPath
        self.didTapIMDB = didTapIMDB
        self.didTapSubDetails = didTapSubDetails
        super.init(cellIdentifier: "MovieDetailsSubDetailsCell")
    }
}

final class MovieDetailsSubDetailsCell: UICollectionViewCell {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let imageSizes: CGFloat = 20
        static let imdbImageSize: CGFloat = 25
        static let cellHeight = 25.0
    }
    
    // MARK: - PROPERTIES
    private var viewModel: MovieDetailsSubDetailsCellViewModel?
    
    // MARK: - VIEW PROPERTIES
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            releaseYearLabel, movieReleasedImageView,
            movieDurationLabel, movieHDStatusImageView,
            mediaTypeImageView, UIView(), imdbImageView
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var releaseYearLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.accessibilityIdentifier = "ReleaseYearLabel"
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTooltip)))
        label.font = CMFont.font(size: .caption, fontName: .avenirDemiBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieReleasedImageView: UIImageView = {
        let image = UIImageView()
        image.accessibilityIdentifier = "ReleasedImage"
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTooltip)))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var movieHDStatusImageView: UIImageView = {
        let image = UIImageView()
        image.accessibilityIdentifier = "HDStatusImage"
        image.image = UIImage(named: ImageNames.HD.rawValue)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTooltip)))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var mediaTypeImageView: UIImageView = {
        let view = UIImageView()
        view.accessibilityIdentifier = "MediaTypeImage"
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTooltip)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieDurationLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "DurationLabel"
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTooltip)))
        label.font = CMFont.font(size: .caption, fontName: .avenirDemiBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imdbImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: ImageNames.imdbLogo.rawValue)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapIMDB)))
        return image
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
        layoutAttributes.frame.size.height = Constants.cellHeight
        return layoutAttributes
    }
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: MovieDetailsSubDetailsCellViewModel) {
        self.viewModel = viewModel
        releaseYearLabel.text = CMDateFormatter.formatToYearOnly(dateString: viewModel.year)
        movieReleasedImageView.image = viewModel.released ?
        UIImage(named: ImageNames.released.rawValue) : UIImage(named: ImageNames.notReleased.rawValue)
        movieReleasedImageView.accessibilityIdentifier = "\(viewModel.released ? "Released" : "NotReleased")Image"
        movieDurationLabel.text = viewModel.duration
        imdbImageView.image = viewModel.imdbPath != nil ? UIImage(named: ImageNames.imdbLogo.rawValue) : nil
        mediaTypeImageView.image = UIImage(named: ImageNames.movieID.rawValue)
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        movieHDStatusImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.imageSizes)
        }
        
        imdbImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.imdbImageSize)
        }
        
        movieReleasedImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.imageSizes)
        }
        
        mediaTypeImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.imageSizes)
        }
        
        contentView.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapIMDB() {
        viewModel?.didTapIMDB?()
    }
    
    @objc private func showTooltip(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        guard let id = view.accessibilityIdentifier else { return }
        viewModel?.didTapSubDetails?(view, id)
    }
}
