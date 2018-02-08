//
//  UIViewExtension.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/6/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import UIKit

extension UIView {

    // MARK: Loading View

    static func loadingIndicator() -> UIActivityIndicatorView {
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        return loadingIndicator
    }
}
