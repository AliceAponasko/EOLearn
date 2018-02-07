//
//  UserDefaultsExtension.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/6/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation

extension UserDefaults {

    // MARK: Constants

    struct Key {
        static let currentUser = "currentUser"
        static let authToken = "authToken"
    }

    // MARK: Clean up

    func clear() {
        set(nil, forKey: Key.currentUser)
        set(nil, forKey: Key.authToken)
    }

    // MARK: User

    func currentUser() -> User? {
        guard let user = object(
            forKey: Key.currentUser) as? Data else {
                return nil
        }

        return try? PropertyListDecoder().decode(User.self, from: user)
    }

    func setCurrentUser(_ user: User) {
        if let data = try? PropertyListEncoder().encode(user) {
            set(data, forKey: Key.currentUser)
        }
    }

    // MARK: Token

    func authToken() -> String? {
        return string(forKey: Key.authToken)
    }

    func setAuthToken(_ token: String) {
        setValue(token, forKey: Key.authToken)
    }
}
