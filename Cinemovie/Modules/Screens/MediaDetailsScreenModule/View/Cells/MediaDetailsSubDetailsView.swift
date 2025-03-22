//
//  CMMovieSubDetailsView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.03.2025.
//

import UIKit
import SnapKit

struct MediaDetailsSubDetailsViewModel: MovieDetailsCellViewModel {
    let identifier: String = "MediaDetailsSubDetailsView"
    
    let year: String
    let released: Bool
    let duration: String
    let imdbPath: String?
    let didTapIMDB: (() -> Void)?
    
    init(year: String, released: Bool, duration: String, imdbPath: String?, didTapIMDB: (() -> Void)? = nil) {
        self.year = year
        self.released = released
        self.duration = duration
        self.imdbPath = imdbPath
        self.didTapIMDB = didTapIMDB
    }
}

final class MediaDetailsSubDetailsView: UICollectionViewCell {

    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let imageSizes: CGFloat = 20
        static let imdbImageSize: CGFloat = 25
    }
    
    // MARK: - STATIC
    static let identifier = "MediaDetailsSubDetailsView"
    
    // MARK: - PROPERTIES
    private var viewModel: MediaDetailsSubDetailsViewModel?
    
    // MARK: - VIEW PROPERTIES
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            movieYearLabel, movieReleasedImageView,
            movieDurationLabel, movieHDStatusImageView,
            UIView(), imdbImageView
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private var movieYearLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.font = CMFont.font(size: .caption, fontName: .avenirDemiBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var movieReleasedImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var movieHDStatusImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: ImageNames.HD.rawValue)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var movieDurationLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
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
    
    // MARK: - PUBLIC FUNC
    public func configure(viewModel: MediaDetailsSubDetailsViewModel) {
        self.viewModel = viewModel
        movieYearLabel.text = CMDateFormatter.formatToYearOnly(dateString: viewModel.year)
        movieReleasedImageView.image = viewModel.released ?
        UIImage(named: ImageNames.released.rawValue) : UIImage(named: ImageNames.notReleased.rawValue)
        movieDurationLabel.text = viewModel.duration
        imdbImageView.image = viewModel.imdbPath != nil ? UIImage(named: ImageNames.imdbLogo.rawValue) : nil
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
        
        contentView.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func didTapIMDB() {
        viewModel?.didTapIMDB?()
    }
}
