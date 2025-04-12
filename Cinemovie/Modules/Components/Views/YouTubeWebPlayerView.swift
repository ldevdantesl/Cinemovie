//
//  YouTubeWebPlayerView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 8.04.2025.
//

import UIKit
import WebKit
import SnapKit

final class YouTubeWebPlayerView: UIView {
 
    // MARK: - PROPERTIES
    private let webView = WKWebView()
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init(video: Video?) {
        self.init(frame: .zero)
        guard let video = video else { return }
        setupUI()
        setupVideo(video: video)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC FUNC
    public func setupVideo(video: Video) {
        guard let embedURL = URLHelper.getYouTubeVideoURL(video: video, playsInline: true) else { return }
        webView.load(URLRequest(url: embedURL))
    }
    
    // MARK: - PRIVATE FUNC
    private func setupUI() {
        addSubview(webView)
        
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
