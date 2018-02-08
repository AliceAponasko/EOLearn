//
//  Loading.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/6/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import UIKit
import PureLayout

protocol Loading: class {

    var isLoading: Bool { get set }
    var loadingIndicator: UIActivityIndicatorView { get }

    func startLoading()
    func stopLoading()
}

extension Loading where Self: UIView {

    func startLoading() {
        isLoading = true

        if !subviews.contains(loadingIndicator) {
            addSubview(loadingIndicator)

            loadingIndicator.autoCenterInSuperview()
            loadingIndicator.autoSetDimension(
                .height,
                toSize: min(40, frame.height - 10))
            loadingIndicator.autoSetDimension(
                .width,
                toSize: min(40, frame.width - 10))
        }

        bringSubview(toFront: loadingIndicator)
        loadingIndicator.alpha = 1.0
        loadingIndicator.isHidden = false
        loadingIndicator.hidesWhenStopped = false
        loadingIndicator.startAnimating()

        layoutIfNeeded()
    }

    func stopLoading() {
        isLoading = false

        loadingIndicator.alpha = 0.0
        loadingIndicator.stopAnimating()
    }

    func isLoading() -> Bool {
        return isLoading
    }
}

extension Loading where Self: UIViewController {

    func startLoading() {
        isLoading = true

        if !view.subviews.contains(loadingIndicator) {
            view.addSubview(loadingIndicator)

            loadingIndicator.autoCenterInSuperview()
            loadingIndicator.autoSetDimension(
                .height,
                toSize: min(40, view.frame.height - 10))
            loadingIndicator.autoSetDimension(
                .width,
                toSize: min(40, view.frame.width - 10))
        }

        view.bringSubview(toFront: loadingIndicator)
        loadingIndicator.alpha = 1.0
        loadingIndicator.isHidden = false
        loadingIndicator.hidesWhenStopped = false
        loadingIndicator.startAnimating()

        view.layoutIfNeeded()
    }

    func stopLoading() {
        isLoading = false

        loadingIndicator.alpha = 0.0
        loadingIndicator.stopAnimating()
    }

    func isLoading() -> Bool {
        return isLoading
    }
}
