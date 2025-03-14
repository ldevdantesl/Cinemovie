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
    func didOpenMoreLikeThis()
    func didRecieveError(_ errorStr: String)
    func didGetMovieDetails(_ details: MovieDetails)
    func didGetMovieCast(cast: [Cast], crew: [Cast])
    func didGetMovieRecommendations(movies: [QueryMovie])
}

final class MovieDetailsScreenVC: UIViewController {
    
    fileprivate enum Paddings {
        static let vertical: CGFloat = 10
        static let horizontal: CGFloat = 15
        static let spacing: CGFloat = 5
        static let biggerSpacing: CGFloat = 8
        static let superSpacing: CGFloat = 15
    }
    
    fileprivate enum Constants {
        static let appName = CONSTANTS.appName
        static let releasedText: String = "Released"
        static let backdropImageHeight = UIConstants.screenHeight/4
        static let addToWatchlistButtonHeight: CGFloat = 40
        static let altImageSize: CGFloat = 20
        static let releasedImageSize: CGFloat = 25
        static let imdbImageSize: CGFloat = 30
        static let closeButtonCornerRadius: CGFloat = 15
        static let closeButtonImageSize: CGFloat = 10
        static let closeButtonViewSize: CGFloat = 30
        static let closeButtonImageName: String = "xmark"
        static let movieCastListHeight: CGFloat = 150
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
        scroll.delegate = self
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIMDBButton))
        
        let view = UIImageView()
        view.image = UIImage(named: ImageNames.imdb.rawValue)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieSubDetailsStackView: UIStackView = {
        let movieSubDetailsStack = UIStackView(arrangedSubviews: [
            movieYearLabel, movieStatusImageView, movieRuntimeLabel,
            hdImageView, UIView(), imdbImageView
        ])
        movieSubDetailsStack.axis = .horizontal
        movieSubDetailsStack.spacing = Paddings.biggerSpacing
        movieSubDetailsStack.alignment = .center
        movieSubDetailsStack.isUserInteractionEnabled = true
        movieSubDetailsStack.translatesAutoresizingMaskIntoConstraints = false
        
        return movieSubDetailsStack
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
    
    private lazy var rateAndShareView: CMRateAndShareView = {
        let view = CMRateAndShareView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieSubDetailsView: CMMovieSubDetailsView = {
        let view = CMMovieSubDetailsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
        
        contentView.addSubview(movieSubDetailsStackView)
        movieSubDetailsStackView.snp.makeConstraints {
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
            $0.top.equalTo(movieSubDetailsStackView.snp.bottom).offset(Paddings.biggerSpacing)
            $0.leading.equalToSuperview().offset(Paddings.horizontal)
            $0.trailing.equalToSuperview().offset(-Paddings.horizontal)
            $0.height.equalTo(Constants.addToWatchlistButtonHeight)
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
        
        contentView.addSubview(rateAndShareView)
        rateAndShareView.snp.makeConstraints {
            $0.top.equalTo(movieProductionCompaniesView.snp.bottom).offset(Paddings.superSpacing)
            $0.leading.equalToSuperview().offset(Paddings.horizontal)
            $0.trailing.equalToSuperview().offset(-Paddings.horizontal)
        }
    
        contentView.addSubview(movieSubDetailsView)
        movieSubDetailsView.snp.makeConstraints {
            $0.top.equalTo(rateAndShareView.snp.bottom).offset(Paddings.superSpacing)
            $0.leading.equalToSuperview().offset(Paddings.horizontal)
            $0.trailing.equalToSuperview().offset(-Paddings.horizontal)
            $0.bottom.equalToSuperview()
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

extension MovieDetailsScreenVC: UIScrollViewDelegate {}

extension MovieDetailsScreenVC: MovieDetailsScreenViewProtocol {
    
    func didOpenMoreLikeThis() {
        presenter?.didOpenMoreLikeThis()
    }
    
    func didRecieveError(_ errorStr: String) {
        let alert = UIAlertController(
            title: "Oops..",
            message: errorStr,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "OK", style: .cancel) {_ in
            self.dismiss(animated: true)
        }

        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didGetMovieDetails(_ details: MovieDetails) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingIndicator.startAnimating()
            self.movieTitleLabel.text = details.title
            self.movieYearLabel.text = String(details.releaseDate.prefix(4))
            self.movieRuntimeLabel.text = RuntimeHelper.runtime(details.runtime)
            
            self.movieTaglineLabel.text = details.tagline.isEmpty ? nil : TextFormatter.formatToCleanString(details.tagline)
            self.movieTaglineLabel.isHidden = details.tagline.isEmpty ? true : false

            self.movieOverviewLabel.text = details.overview
            self.movieProductionCompaniesView.configure(companies: details.productionCompanies)
            self.movieStatusImageView.image = details.status == Constants.releasedText ?
            UIImage(named: ImageNames.released.rawValue) : UIImage(named: ImageNames.notReleased.rawValue)
            self.movieStatusImageView.accessibilityIdentifier = details.status == Constants.releasedText ? "Re" : "Nr"
            
            self.imdbImageView.accessibilityIdentifier = details.imdbID
            self.imdbImageView.isHidden = details.imdbID == nil ? true : false
            
            if let imageURL = URLHelper.getImageURL(with: details.backdropPath, size: .original){
                self.backdropImageView.sd_setImage(with: imageURL) { _, _, _, _ in
                    self.loadingIndicator.stopAnimating()
                }
            } else {
                self.backdropImageView.image = UIImage(systemName: "questionmark.circle.fill")
                self.backdropImageView.preferredSymbolConfiguration = .init(pointSize: 40, weight: .bold)
                self.backdropImageView.contentMode = .center
                self.loadingIndicator.stopAnimating()
            }
            
            self.movieSubDetailsView.configureCollections(with: details)
            self.view.layoutIfNeeded()
        }
    }
    
    func didGetMovieCast(cast: [Cast], crew: [Cast]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.movieCastListView.reloadData(cast: cast.isEmpty ? crew : cast)
        }
    }
    
    func didGetMovieRecommendations(movies: [QueryMovie]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            print("Recommends: \(movies.count)")
            self.movieSubDetailsView.configureRecommendations(recommendationMovies: movies)
        }
    }
}
