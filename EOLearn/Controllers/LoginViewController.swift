//
//  LoginViewController.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/6/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, Loading {

    // MARK: Constants

    private let apiClient = APIClient.shared

    private enum Segue: String {
        case openCourses
    }

    // MARK: Properties

    private var email = ""
    private var password = ""

    // MARK: Loading

    var isLoading: Bool = false
    var loadingIndicator = UIView.loadingIndicator()

    // MARK: Outlets

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        emailTextField.becomeFirstResponder()
    }

    // MARK: Actions

    @IBAction func didChangeEmailText(_ sender: UITextField) {
        email = emailTextField.text ?? ""
    }

    @IBAction func didChangePasswordText(_ sender: UITextField) {
        password = passwordTextField.text ?? ""
    }

    @IBAction func didTapSignIn(_ sender: Any) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()

        if isFormFilledOut() {
            login()
        }
    }

    // MARK: Login

    private func login() {
        view.isUserInteractionEnabled = false

        apiClient.loginUser(
            email: email,
            password: password,
            sender: self) { [weak self] result in

                guard let strongSelf = self else {
                    return
                }

                strongSelf.view.isUserInteractionEnabled = true

                switch result {
                case .success:
                    strongSelf.openCourses()

                case .failure(let error):
                    if error == .general {
                        strongSelf.showErrorAlert(
                            title: Const.Error.Login.loginFailedTitle,
                            message: Const.Error.Login.loginFailedText)
                        return
                    }

                    strongSelf.handleRequestError(error)
                }
        }
    }

    // MARK: Segue

    func openCourses() {
        performSegue(
            withIdentifier: Segue.openCourses.rawValue,
            sender: self)
    }

    // MARK: Helpers

    func isFormFilledOut() -> Bool {
        if email.count == 0 {
            showErrorAlert(
                title: Const.Error.Login.missingFieldTitle,
                message: Const.Error.Login.enterEmailText)

            return false
        } else if password.count == 0 {
            showErrorAlert(
                title: Const.Error.Login.missingFieldTitle,
                message: Const.Error.Login.enterPasswordText)

            return false
        } else {

            return true
        }
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            email = emailTextField.text ?? ""
        } else if textField == passwordTextField {
            password = passwordTextField.text ?? ""
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {

            passwordTextField.becomeFirstResponder()

        } else if textField == passwordTextField {

            if passwordTextField.returnKeyType == .done {
                passwordTextField.resignFirstResponder()
                didTapSignIn(self)
            }
        }

        return true
    }
}
