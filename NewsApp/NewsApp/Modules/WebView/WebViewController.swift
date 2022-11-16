//
//  WebViewController.swift
//  NewsApp
//
//  Created by Kate on 16.11.2022.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    // MARK: - Subviews

    private let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()

    // MARK: - Private properties

    private let url: URL

    // MARK: - Lifecycle

    init(url: URL) {
        self.url = url

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.load(URLRequest(url: url))
    }
}

// MARK: - WKUIDelegate

extension WebViewController: WKUIDelegate {
}
