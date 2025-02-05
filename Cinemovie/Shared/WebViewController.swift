//
//  WKWebView.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation
import UIKit
import WebKit

final class WebViewController: UIViewController {
    private var webView: WKWebView!
    private var urlString: String

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
