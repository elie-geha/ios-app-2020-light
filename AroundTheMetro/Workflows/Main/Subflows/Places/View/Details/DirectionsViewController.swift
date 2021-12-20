//
//  DirectionsViewController.swift
//  AroundTheMetro
//
//  Created by Muhammad Fahad Baig on 21/12/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import UIKit
import WebKit

class DirectionsViewController: UIViewController {

    @IBOutlet weak var webViewMap: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.google.com")!
                let urlRequest = URLRequest(url: url)

        webViewMap.load(urlRequest)
        webViewMap.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }

}
