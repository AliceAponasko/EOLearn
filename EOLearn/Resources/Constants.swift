//
//  Constants.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/6/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation

struct Const {

    struct General {
        static let okButtonTitle = "OK"
    }

    struct Error {

        static let errorTitle = "Oops!"
        static let errorText = "Something is wrong."

        static let noInternetTitle = "No Connection"
        static let noInternetText = "Connect to Internet and try again."

        struct Login {
            static let missingFieldTitle = "Missing Field"
            static let enterEmailText = "Enter your email."
            static let enterPasswordText = "Enter your password."

            static let loginFailedTitle = "Login Failed"
            static let loginFailedText = "Check your email and password format."
        }
    }
}

struct Api {

    struct Endpoint {
        static let login = "/v1/tokens"
    }

    struct StatusCode {
        static let success = 200

        static let badRequest = 400
        static let unauthorized = 401
    }
}
