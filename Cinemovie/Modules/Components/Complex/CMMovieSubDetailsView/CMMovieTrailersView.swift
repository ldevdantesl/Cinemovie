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
        static let vStackSpacing: CGFloat = 10
        static let innerStackSpacing: CGFloat = 5
        static let webViewCornerRadius: CGFloat = 10
        static let webViewHeight: CGFloat = 200
    }
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.vStackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
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
            videos.forEach(loadYoutubeVideo)
        }
    }
    
    // MARK: - Private functions
    private func setupUI() {
        addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func loadYoutubeVideo(video: DomainVideo) {
        guard video.site == .youtube else { return }
        guard video.type == .trailer || video.type == .teaser else { return }
        guard let videoURL = URLHelper.getYouTubeVideoURL(video: video) else { return }
        
        let innerStack = UIStackView()
        innerStack.axis = .vertical
        innerStack.spacing = Constants.innerStackSpacing
        innerStack.alignment = .leading
        innerStack.translatesAutoresizingMaskIntoConstraints = false

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
        videoLabel.font = CMFont.font(size: .tiny, fontName: .avenir)
        videoLabel.translatesAutoresizingMaskIntoConstraints = false
        innerStack.addArrangedSubview(videoLabel)
        
        vStack.addArrangedSubview(innerStack)
        vStack.layoutIfNeeded()
    }
}
