//
//  UIViewControllerExtension.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/6/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import UIKit

extension UIViewController {

    // MARK: Error

    func showErrorAlert(
        title: String,
        message: String) {

        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)

        alertController.addAction(UIAlertAction(
            title: Const.General.okButtonTitle,
            style: .default, handler: nil))

        present(
            alertController,
            animated: true,
            completion: nil)
    }

    func handleRequestError(_ error: ApiError) {
        switch error {
        case .general:
            showErrorAlert(
                title: Const.Error.errorTitle,
                message: Const.Error.errorText)

        case .noInternet:
            showErrorAlert(
                title: Const.Error.noInternetTitle,
                message: Const.Error.noInternetText)

        case .sessionExpired:
            navigationController?.popToRootViewController(animated: true)
        }
    }
}
