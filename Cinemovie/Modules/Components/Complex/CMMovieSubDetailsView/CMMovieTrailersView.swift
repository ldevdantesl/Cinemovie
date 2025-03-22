//
//  CMMovieTrailersAndMoreView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 13.03.2025.
//

import UIKit
import SnapKit
import WebKit

final class CMMovieTrailersView: UIView {
    
    // MARK: - CONSTANTS
    fileprivate enum Constants {
        static let spacing: CGFloat = 5
        static let vStackSpacing: CGFloat = 10
        static let innerStackSpacing: CGFloat = 5
        static let webViewCornerRadius: CGFloat = 10
        static let webViewHeight: CGFloat = 200
        static let imageName: String = "play.square.stack.fill"
        static let imageSize: CGFloat = 20
    }
    
    // MARK: - PROPERTIES
    private var videos: [DomainVideo] = []
    private var filteredVideos: [DomainVideo] = []
    
    private lazy var trailersLabel: UILabel = {
        let label = UILabel()
        label.text = "Trailers"
        label.textColor = CMColor.cmLabel
        label.font = CMFont.font(size: .body, fontName: .avenirDemiBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trailersCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = CMColor.cmSecondary
        label.textAlignment = .left
        label.font = CMFont.font(size: .caption, fontName: .avenirDemiBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var changeVideoTypeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.imageName), for: .normal)
        button.tintColor = CMColor.cmAccent
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.vStackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var innerStack: UIStackView = {
        let innerStack = UIStackView()
        innerStack.axis = .vertical
        innerStack.spacing = Constants.innerStackSpacing
        innerStack.alignment = .leading
        innerStack.translatesAutoresizingMaskIntoConstraints = false
        return innerStack
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
    
    // MARK: - Public functions
    public func configure(videos: [DomainVideo]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.videos = videos
            self.filteredVideos = videos.filter { $0.type == .trailer }
            
            let uniqueTypes = Set(videos.map { $0.type })
            var menuChildren: [UIAction] = []
            uniqueTypes.forEach { type in
                let action = UIAction(title: type.rawValue) { _ in
                    self.filterVideos(by: type)
                }
                menuChildren.append(action)
            }

            changeVideoTypeButton.menu = UIMenu(title: "Change Video Type", children: menuChildren)
            changeVideoTypeButton.showsMenuAsPrimaryAction = true
            self.filteredVideos.forEach(loadYoutubeVideo)
            trailersCountLabel.text = "\(filteredVideos.count)"
        }
    }
    
    // MARK: - Private functions
    private func setupUI() {
        addSubview(trailersLabel)
        trailersLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        addSubview(changeVideoTypeButton)
        changeVideoTypeButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.width.equalTo(Constants.imageSize)
        }
        
        addSubview(trailersCountLabel)
        trailersCountLabel.snp.makeConstraints {
            $0.leading.equalTo(trailersLabel.snp.trailing).offset(Constants.spacing)
            $0.bottom.equalTo(trailersLabel.snp.bottom)
        }
        
        addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.top.equalTo(trailersLabel.snp.bottom).offset(Constants.vStackSpacing)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func loadYoutubeVideo(video: DomainVideo) {
        guard video.site == .youtube else { return }
        guard let videoURL = URLHelper.getYouTubeVideoURL(video: video) else { return }

        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        
        let wkView = WKWebView(frame: .zero, configuration: config)
        wkView.translatesAutoresizingMaskIntoConstraints = false
        wkView.clipsToBounds = true
        wkView.layer.cornerRadius = Constants.webViewCornerRadius
        wkView.load(URLRequest(url: videoURL))
        
        innerStack.addArrangedSubview(wkView)
        wkView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.webViewHeight)
        }
        
        let videoLabel = UILabel()
        videoLabel.text = video.name
        videoLabel.textColor = CMColor.cmSecondary
        videoLabel.font = CMFont.font(size: .tiny, fontName: .avenirDemiBold)
        videoLabel.translatesAutoresizingMaskIntoConstraints = false
        innerStack.addArrangedSubview(videoLabel)
        
        vStack.addArrangedSubview(innerStack)
        vStack.layoutIfNeeded()
    }
    
    private func filterVideos(by type: VideoType) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.filteredVideos = self.videos.filter { $0.type == type }
            UIView.animate(withDuration: 0.3){
                self.innerStack.arrangedSubviews.forEach { $0.alpha = 0 }
                self.innerStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
                self.filteredVideos.forEach(self.loadYoutubeVideo)
                self.trailersCountLabel.text = "\(self.filteredVideos.count)"
                self.trailersLabel.text = type.rawValue.capitalized + "s"
            }
        }
    }
}
