//
//  LoginUser.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/6/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation

enum LoginResult {
    case success(String)
    case failure(ApiError)
}

private struct RequestKey {
    static let email = "X-User-Email"
    static let password = "X-User-Password"
}

extension APIClient {

    // MARK: Login user

    func loginUser(
        email: String,
        password: String,
        sender: Loading?,
        completion: @escaping ((LoginResult) -> Void)) {

        if let sender = sender {
            if sender.isLoading {
                return
            }
        }

        let parameters: [String: Any] = [
            RequestKey.email: email.lowercased().trim(),
            RequestKey.password: password ]

        sender?.startLoading()

        post(
            Api.Endpoint.login,
            parameters: parameters,
            tokenRequired: false) { [weak self] apiRequestResult in
                guard let strongSelf = self else {
                    return
                }

                mainQueue {
                    switch apiRequestResult {
                    case .success(let data):
                        sender?.stopLoading(success: true)
                        completion(strongSelf.parse(data))

                    case .failure(let error, _):
                        sender?.stopLoading(success: false)
                        log.error("Failed to login user")

                        completion(.failure(error))

                    }
                }
        }
    }

    private func parse(_ data: Data) -> LoginResult {
        let decoder = JSONDecoder()
        do {
            let token = try decoder.decode(AuthToken.self, from: data)

            userDefaults.setAuthToken(token.token)

            log.info("User is successfully logged in")

            return .success(token.token)
        } catch {
            log.error("Failed to parse user from json: " +
                "\(String(describing: try? JSONSerialization.jsonObject(with: data, options: [])))")
            return .failure(.general)
        }
    }
}
