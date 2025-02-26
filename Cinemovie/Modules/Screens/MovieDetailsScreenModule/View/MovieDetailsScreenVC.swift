//
//  MovieDetailsScreenVC.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

import UIKit
import SnapKit
import SDWebImage

protocol MovieDetailsScreenViewProtocol: AnyObject {
    func didRecieveError(_ errorStr: String)
    func didGetMovieDetails(_ details: MovieDetails)
}

final class MovieDetailsScreenVC: UIViewController {

    private enum Paddings {
        static let vertical: CGFloat = 10
        static let horizontal: CGFloat = 15
        static let spacing: CGFloat = 5
        static let biggerSpacing: CGFloat = 8
    }
    
    private enum Constants {
        static let appName = CONSTANTS.appName
        static let backdropImageHeight = UIConstants.screenHeight/4
        static let altImageSize: CGFloat = 20
        static let releasedImageSize: CGFloat = 25
        static let imdbImageSize: CGFloat = 30
        static let closeButtonCornerRadius: CGFloat = 15
        static let closeButtonImageSize: CGFloat = 10
        static let closeButtonViewSize: CGFloat = 30
        static let closeButtonImageName: String = "xmark"
    }
    
    var presenter: MovieDetailsScreenPresenterProtocol?
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(configuration: .borderless())
        button.tintColor = CMColor.cmButton
        button.setImage(UIImage(systemName: Constants.closeButtonImageName), for: .normal)
        button.backgroundColor = CMColor.cmSecondary
        button.layer.cornerRadius = Constants.closeButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: Constants.closeButtonImageSize, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backdropImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = CMColor.cmDivider
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var cinemovieLogoAltStackView: UIStackView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.appName
        label.font = CMFont.font(size: .caption, weight: .bold)
        label.textColor = CMColor.cmSecondary
        
        let logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: ImageNames.logoAlt.rawValue)
        
        let view = UIStackView(arrangedSubviews: [logoImageView,label])
        view.axis = .horizontal
        view.spacing = Paddings.spacing
        view.alignment = .bottom
        
        view.addSubview(logoImageView)
        view.addSubview(label)
        logoImageView.snp.makeConstraints {
            $0.width.height.equalTo(Constants.altImageSize)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.font = CMFont.font(size: .subtitle, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieStatusImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var movieYearLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenir)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var hdImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: ImageNames.HD.rawValue)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var imdbImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieRuntimeLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenir)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupUI()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualTo(scrollView.snp.height)
        }
        
        contentView.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Paddings.vertical)
            $0.trailing.equalToSuperview().offset(-Paddings.horizontal)
            $0.width.height.equalTo(Constants.closeButtonViewSize)
        }
        
        contentView.addSubview(backdropImageView)
        backdropImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.backdropImageHeight)
        }
        
        backdropImageView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        contentView.addSubview(cinemovieLogoAltStackView)
        cinemovieLogoAltStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Paddings.horizontal)
            $0.trailing.equalToSuperview().offset(-Paddings.horizontal)
            $0.top.equalTo(backdropImageView.snp.bottom).offset(Paddings.vertical)
        }
        
        contentView.addSubview(movieTitleLabel)
        movieTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Paddings.horizontal)
            $0.trailing.equalToSuperview().offset(-Paddings.horizontal)
            $0.top.equalTo(cinemovieLogoAltStackView.snp.bottom).offset(Paddings.spacing)
        }
        
        let movieSubDetailsStack = UIStackView(arrangedSubviews: [
            movieYearLabel, movieStatusImageView, movieRuntimeLabel,
            hdImageView, imdbImageView, UIView()
        ])
        movieSubDetailsStack.axis = .horizontal
        movieSubDetailsStack.spacing = Paddings.biggerSpacing
        movieSubDetailsStack.alignment = .center
        movieSubDetailsStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(movieSubDetailsStack)
        movieSubDetailsStack.snp.makeConstraints {
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(Paddings.spacing)
            $0.leading.equalToSuperview().offset(Paddings.horizontal)
            $0.trailing.equalToSuperview().offset(-Paddings.horizontal)
        }
        
        movieStatusImageView.snp.makeConstraints {
            $0.width.height.equalTo(Constants.releasedImageSize)
        }
        
        hdImageView.snp.makeConstraints {
            $0.width.height.equalTo(Constants.altImageSize)
        }
        
        imdbImageView.snp.makeConstraints {
            $0.width.height.equalTo(Constants.imdbImageSize)
        }
        
        contentView.bringSubviewToFront(closeButton)
    }
    
    // MARK: - OBJC FUNCTIONS
    @objc private func close() {
        dismiss(animated: true)
    }
    @objc private func openIMDB() {
        guard let id = imdbImageView.accessibilityIdentifier else { return }
        guard let url = URLHelper.getImdbURL(withID: id) else { return }
        AppOpener.openURL(url)
    }
}

extension MovieDetailsScreenVC: MovieDetailsScreenViewProtocol {
    func didRecieveError(_ errorStr: String) {
        let alert = UIAlertController(
            title: "Oops..",
            message: errorStr,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "OK", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    func didGetMovieDetails(_ details: MovieDetails) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingIndicator.startAnimating()
            self.movieTitleLabel.text = details.title
            self.movieYearLabel.text = String(details.releaseDate.prefix(4))
            self.movieRuntimeLabel.text = RuntimeHelper.runtime(details.runtime)
            self.movieStatusImageView.image = details.status == "Released" ?
            UIImage(named: ImageNames.released.rawValue) : UIImage(named: ImageNames.notReleased.rawValue)
            
            if let imdbID = details.imdbID {
                self.imdbImageView.image = UIImage(named: ImageNames.imdb.rawValue)
                self.imdbImageView.accessibilityIdentifier = imdbID
                self.imdbImageView.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openIMDB))
                self.imdbImageView.addGestureRecognizer(tapGesture)
            }
            
            let imageURL = URLHelper.getImageURL(with: details.backdropPath, size: .original)
            self.backdropImageView.sd_setImage(with: imageURL) { _, _, _, _ in
                self.loadingIndicator.stopAnimating()
            }
        }
    }
}
