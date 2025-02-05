//
//  WKWebView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation
import UIKit
import WebKit

protocol WebViewControllerDelegate: AnyObject {
    func didReceiveOAuthCallback(url: URL)
}

final class WebViewController: UIViewController {
    private var webView: WKWebView!
    private var urlString: String
    weak var delegate: WebViewControllerDelegate?

    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadURL()
    }

    private func setupWebView() {
        webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
    }

    private func loadURL() {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
    ) {
        if let url = navigationAction.request.url {
            print("Navigating to URL: \(url.absoluteString)") // Debug log
            
            if url.scheme == "cinemovie" { // Detect custom scheme
                print("OAuth Callback detected: \(url.absoluteString)") // Confirm detection
                
                delegate?.didReceiveOAuthCallback(url: url) // Notify presenter
                dismiss(animated: true) // Close WebView
                
                // Manually open the URL (to ensure it redirects)
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
                decisionHandler(.cancel) // Stop WebView from blocking it
                return
            }
        }
        decisionHandler(.allow) 
    }
}
