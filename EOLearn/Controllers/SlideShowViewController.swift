//
//  SlideShowViewController.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/7/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import UIKit
import WebKit

class SlideShowViewController: UIViewController {

    // MARK: Parameters

    var slideShowUrl: String!

    // MARK: Outlets

    @IBOutlet weak var webView: WKWebView!

    // MARK: Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let url = URL(string: slideShowUrl) else {
            return
        }

        webView.load(URLRequest(url: url))
    }
    
}
