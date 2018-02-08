//
//  SlideShowViewController.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/7/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class SlideShowViewController: UIViewController, Loading {

    // MARK: Constants

    private let apiClient = APIClient.shared

    // MARK: Parameters

    var slideShowUrl: String!

    // MARK: Outlets

    @IBOutlet weak var webView: WKWebView!

    // MARK: Loading

    var isLoading: Bool = false
    var loadingIndicator = UIView.loadingIndicator()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        apiClient.downloadSlideShow(
        url: slideShowUrl,
        sender: self) { [weak self] result in

            switch result {
            case .success(let slideShowPath):
                self?.webView.loadFileURL(
                    URL(fileURLWithPath: slideShowPath),
                    allowingReadAccessTo: URL(fileURLWithPath: slideShowPath))

            case .failure:
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
