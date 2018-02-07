//
//  APIClient.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/6/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation
import Alamofire
import ReachabilitySwift

enum ApiError: Error {
    case general
    case noInternet
    case sessionExpired
}

enum ApiRequestResult {
    case success(data: Data)
    case failure(
        ApiError,
        response: DefaultDataResponse?)
}

class APIClient {

    static let shared = APIClient()

    // MARK: Constants

    let baseURLString = Bundle.apiURL()
    let baseApiToken = Bundle.apiToken()
    let userDefaults = UserDefaults.standard

    func get(
        _ path: String,
        parameters: Parameters?,
        tokenRequired: Bool = true,
        completion: @escaping (ApiRequestResult) -> Void) {

        request(
            .get,
            path: path,
            parameters: parameters,
            tokenRequired: tokenRequired,
            completion: completion)
    }

    func post(
        _ path: String,
        parameters: Parameters?,
        tokenRequired: Bool = true,
        completion: @escaping (ApiRequestResult) -> Void) {

        request(
            .post,
            path: path,
            parameters: parameters,
            tokenRequired: tokenRequired,
            completion: completion)
    }

    private func request(
        _ method: Alamofire.HTTPMethod,
        path: String,
        parameters: Parameters? = nil,
        tokenRequired: Bool,
        completion: @escaping (ApiRequestResult) -> Void) {

        guard let fullURL = URL(
            string: "\(baseURLString)\(path)") else {

                completion(.failure(.general, response: nil))
                return
        }

        var headers: [String: String] = [
            "Content-Type": "application/json",
            "X-Partner-Token": baseApiToken
        ]

        if tokenRequired {
            headers["X-User-Token"] = tokenString()
        }

        if let parameters = parameters as? [String: String] {
            for (k, v) in parameters {
                headers[k] = v
            }
        }

        guard var request = try? URLRequest(
            url: fullURL,
            method: method,
            headers: headers) else {
                completion(.failure(.general, response: nil))
                return
        }
        
        request.cachePolicy = .reloadIgnoringCacheData

        Alamofire.request(request)
            .response { [weak self] response in

                self?.parseResponse(response) { result in
                    completion(result)
                }
        }
    }

    // MARK: Helpers

    func tokenString() -> String {
        if let token = userDefaults.authToken() {
            return token
        } else {
            return ""
        }
    }

    func parseResponse(
        _ response: DefaultDataResponse,
        completion: @escaping (ApiRequestResult) -> Void) {

        if let url = response.request?.url {
            log.debug("\(url)")
        }

        if let apiError = didReturnError(response) {
            guard response.data != nil else {
                completion(.failure(
                    apiError,
                    response: response))
                return
            }
        }

        guard let data = response.data else {
            completion(.failure(
                ApiError.general,
                response: response))

            return
        }

        completion(.success(data: data))
    }

    private func didReturnError(
        _ response: DefaultDataResponse) -> ApiError? {

        if response.error != nil {
            if let error = response.error {
                log.error(error.localizedDescription)
            }

            if !hasInternetConnection() {
                return ApiError.noInternet
            }

            return ApiError.general
        }

        guard response.data != nil else {
            log.error("Request data is empty")
            return ApiError.general
        }

        guard let statusCode = response.response?.statusCode else {
            log.error("Request status code is empty")
            return ApiError.general
        }

        if let apiError = isErrorStatusCode(statusCode) {
            log.error("Request status code is \(statusCode)")
            return apiError
        }

        return nil
    }

    private func isErrorStatusCode(
        _ statusCode: Int) -> ApiError? {

        if !hasInternetConnection() {
            return ApiError.noInternet
        }

        let generalStatus = Int(statusCode / 100) * 100

        switch generalStatus {
        case Api.StatusCode.success:
            return nil

        case Api.StatusCode.badRequest:
            switch statusCode {
            case Api.StatusCode.unauthorized:
                return ApiError.sessionExpired

            default:
                return ApiError.general
            }

        default:
            return nil
        }
    }

    func hasInternetConnection() -> Bool {
        guard let reachability = Reachability() else {
            return true
        }

        if reachability.currentReachabilityStatus == .notReachable {
            return false
        }

        return true
    }
}
