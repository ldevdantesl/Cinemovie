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
    func didGetMovieCast(cast: [Cast], crew: [Cast])
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
        static let movieCastListHeight: CGFloat = 140
    }
    
    var presenter: MovieDetailsScreenPresenterProtocol?
    
    private var activeTooltip: CMTooltipView?
    
    private var tooltipDismissWorkItem: DispatchWorkItem?
    
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
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
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
    
    private lazy var movieTaglineLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .footnote, fontName: .avenir)
        label.numberOfLines = 1
        label.textColor = CMColor.cmSecondary
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieYearLabel: UILabel = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSubDetails))
        
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenir)
        label.isUserInteractionEnabled = true
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private lazy var movieStatusImageView: UIImageView = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSubDetails))
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGesture)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var movieRuntimeLabel: UILabel = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSubDetails))
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenir)
        label.textColor = CMColor.cmLabel
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var hdImageView: UIImageView = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSubDetails))
        let image = UIImageView()
        image.image = UIImage(named: ImageNames.HD.rawValue)
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGesture)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var imdbImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addToWatchListButton: CMButton = {
        let button = CMButton(
            text: "Watchlist",
            foreColor: CMColor.cmDivider,
            textFont: CMFont.font(size: .body, fontName: .avenir),
            image: UIImage(systemName: "plus"),
            backColor: .cmLabel,
            cornerRadius: 10
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var movieOverviewLabel: UILabel = {
        let label = UILabel()
        label.font = CMFont.font(size: .caption, fontName: .avenir)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = CMColor.cmLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieCastListView: CMMovieCastList = {
        let view = CMMovieCastList()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieProductionCompaniesView: CMProductionCompaniesView = {
        let view = CMProductionCompaniesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
        contentView.addSubview(movieTaglineLabel)
        movieTaglineLabel.snp.makeConstraints {
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(Paddings.spacing)
            $0.leading.equalToSuperview().offset(Paddings.horizontal)
            $0.trailing.equalToSuperview().offset(-Paddings.horizontal)
        }
        
        let movieSubDetailsStack = UIStackView(arrangedSubviews: [
            movieYearLabel, movieStatusImageView, movieRuntimeLabel,
            hdImageView, UIView(), imdbImageView
        ])
        movieSubDetailsStack.axis = .horizontal
        movieSubDetailsStack.spacing = Paddings.biggerSpacing
        movieSubDetailsStack.alignment = .center
        movieSubDetailsStack.isUserInteractionEnabled = true
        movieSubDetailsStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(movieSubDetailsStack)
        movieSubDetailsStack.snp.makeConstraints {
            $0.top.equalTo(movieTaglineLabel.snp.bottom).offset(Paddings.biggerSpacing)
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
        
        contentView.addSubview(addToWatchListButton)
        addToWatchListButton.snp.makeConstraints {
            $0.top.equalTo(movieSubDetailsStack.snp.bottom).offset(Paddings.biggerSpacing)
            $0.leading.equalToSuperview().offset(Paddings.horizontal)
            $0.trailing.equalToSuperview().offset(-Paddings.horizontal)
            $0.height.equalTo(40)
        }
        
        contentView.addSubview(movieOverviewLabel)
        movieOverviewLabel.snp.makeConstraints {
            $0.top.equalTo(addToWatchListButton.snp.bottom).offset(Paddings.vertical)
            $0.leading.equalToSuperview().offset(Paddings.horizontal)
            $0.trailing.equalToSuperview().offset(-Paddings.horizontal)
        }
        
        contentView.addSubview(movieCastListView)
        movieCastListView.snp.makeConstraints {
            $0.top.equalTo(movieOverviewLabel.snp.bottom).offset(Paddings.spacing)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(Constants.movieCastListHeight)
        }
        
        contentView.addSubview(movieProductionCompaniesView)
        movieProductionCompaniesView.snp.makeConstraints {
            $0.top.equalTo(movieCastListView.snp.bottom).offset(Paddings.vertical)
            $0.leading.equalToSuperview().offset(Paddings.horizontal)
            $0.trailing.equalToSuperview().offset(-Paddings.horizontal)
        }
        
        contentView.bringSubviewToFront(closeButton)
    }
    
    private func showTooltip(from sourceView: UIView, text: String) {
        activeTooltip?.dismiss()
        tooltipDismissWorkItem?.cancel()
        
        let tooltip = CMTooltipView(text: text)
        activeTooltip = tooltip
        tooltip.show(from: sourceView, in: self.view)

        let workItem = DispatchWorkItem { [weak self] in
            self?.activeTooltip?.dismiss()
            self?.activeTooltip = nil
            self?.tooltipDismissWorkItem = nil
        }
        
        tooltipDismissWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: workItem)
    }
    
    // MARK: - OBJC FUNCTIONS
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapIMDBButton() {
        guard let id = imdbImageView.accessibilityIdentifier else { return }
        guard let url = URLHelper.getImdbURL(withID: id) else { return }
        AppOpener.openURL(url)
    }
    
    @objc private func didTapSubDetails(_ sender: UITapGestureRecognizer) {
        guard let tappedLabel = sender.view else { print("cant find sender"); return }
        
        let explanationText: String
        switch tappedLabel {
        case movieYearLabel: explanationText = "Release Year"
        case movieRuntimeLabel: explanationText = "Duration of movie"
        case hdImageView: explanationText = "HD Resolution Available"
        case movieStatusImageView: explanationText = movieStatusImageView.accessibilityIdentifier == "Re" ? "Released" : "Not Released"
        default: return
        }
        
        showTooltip(from: tappedLabel, text: explanationText)
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
            self.movieTaglineLabel.text = TextFormatter.formatToCleanString(details.tagline)
            self.movieOverviewLabel.text = details.overview
            self.movieProductionCompaniesView.configure(companies: details.productionCompanies)
            self.movieStatusImageView.image = details.status == "Released" ?
            UIImage(named: ImageNames.released.rawValue) : UIImage(named: ImageNames.notReleased.rawValue)
            self.movieStatusImageView.accessibilityIdentifier = details.status == "Released" ? "Re" : "Nr"
            
            if let imdbID = details.imdbID {
                self.imdbImageView.image = UIImage(named: ImageNames.imdb.rawValue)
                self.imdbImageView.accessibilityIdentifier = imdbID
                self.imdbImageView.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIMDBButton))
                self.imdbImageView.addGestureRecognizer(tapGesture)
            }
            
            let imageURL = URLHelper.getImageURL(with: details.backdropPath, size: .original)
            self.backdropImageView.sd_setImage(with: imageURL) { _, _, _, _ in
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    func didGetMovieCast(cast: [Cast], crew: [Cast]) {
        DispatchQueue.main.async { [weak self] in
            print(cast.count, crew.count)
            guard let self = self else { return }
            self.movieCastListView.reloadData(cast: cast)
        }
    }
}
