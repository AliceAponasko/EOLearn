//
//  CourseRequest.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/7/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation

enum CourseResult {
    case success(Course)
    case failure(ApiError)
}

extension APIClient {

    // MARK: Course by id

    func course(
        id: Int,
        sender: Loading?,
        completion: @escaping ((CourseResult) -> Void)) {

        if let sender = sender {
            if sender.isLoading {
                return
            }
        }

        sender?.startLoading()

        get(
            "\(Api.Endpoint.course)\(id)",
            parameters: nil,
            tokenRequired: true) { [weak self] apiRequestResult in
                guard let strongSelf = self else {
                    return
                }

                mainQueue {
                    switch apiRequestResult {
                    case .success(let data):
                        sender?.stopLoading()
                        completion(strongSelf.parse(data))

                    case .failure(let error, _):
                        sender?.stopLoading()
                        log.error("Failed to fetch course \(id)")

                        completion(.failure(error))

                    }
                }
        }
    }

    private func parse(_ data: Data) -> CourseResult {
        let decoder = JSONDecoder()
        do {
            let course = try decoder.decode(Course.self, from: data)

            log.info("Course \(course.id) is successfully fetched")

            return .success(course)
        } catch {
            log.error("Failed to parse course from json: " +
                "\(String(describing: try? JSONSerialization.jsonObject(with: data, options: [])))")
            return .failure(.general)
        }
    }
}
