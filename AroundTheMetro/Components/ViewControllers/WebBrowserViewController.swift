//
//  WebBrowserViewController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 02.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import SVProgressHUD
import UIKit
import WebKit

class WebBrowserViewController: UIViewController {
    private var webView: WKWebView!

    var url: URL? {
        didSet {
            if isViewLoaded, let url = url {
                webView.load(URLRequest(url: url))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        webView.navigationDelegate = self

        if let url = url {
            SVProgressHUD.show()
            webView.load(URLRequest(url: url))
        }
    }
}

extension WebBrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()
    }
}
