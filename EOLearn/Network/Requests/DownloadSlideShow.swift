//
//  DownloadSlideShow.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/7/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation
import Alamofire

enum DownloadSlideShowResult {
    case success(String)
    case failure(ApiError)
}

extension APIClient {

    // MARK: Download slide show

    func downloadSlideShow(
        url: String,
        sender: Loading?,
        completion: @escaping ((DownloadSlideShowResult) -> Void)) {

        if let sender = sender {
            if sender.isLoading {
                return
            }
        }

        sender?.startLoading()

        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("slideshow.pptx")

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        Alamofire.download(url, to: destination)
            .response { [weak self] response in
                guard let strongSelf = self else {
                    return
                }
                sender?.stopLoading()
                completion(strongSelf.parseResponse(response))
        }
    }

    func parseResponse(
        _ response: DefaultDownloadResponse) -> DownloadSlideShowResult {

        if let url = response.request?.url {
            log.debug("\(url)")
        }

        if let apiError = didReturnError(response) {
            return .failure(apiError)
        }

        guard let slideShowPath = response.destinationURL?.path else {
            return .failure(.general)
        }

        return .success(slideShowPath)
    }

    func didReturnError(
        _ response: DefaultDownloadResponse) -> ApiError? {

        if response.error != nil {
            if let error = response.error {
                log.error(error.localizedDescription)
            }

            if !hasInternetConnection() {
                return ApiError.noInternet
            }

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
}
