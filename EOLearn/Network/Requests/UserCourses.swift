//
//  UserCourses.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/7/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation

enum UserCoursesResult {
    case success([CourseId])
    case failure(ApiError)
}

extension APIClient {

    // MARK: User courses

    func userCourses(
        sender: Loading?,
        completion: @escaping ((UserCoursesResult) -> Void)) {

        if let sender = sender {
            if sender.isLoading {
                return
            }
        }

        sender?.startLoading()

        get(
            Api.Endpoint.courses,
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
                        log.error("Failed to fetch course IDs")

                        completion(.failure(error))

                    }
                }
        }
    }

    private func parse(_ data: Data) -> UserCoursesResult {
        let decoder = JSONDecoder()
        do {
            let courseIds = try decoder.decode([CourseId].self, from: data)

            log.info("Course IDs are successfully fetched")

            return .success(courseIds)
        } catch {
            log.error("Failed to parse course IDs from json: " +
                "\(String(describing: try? JSONSerialization.jsonObject(with: data, options: [])))")
            return .failure(.general)
        }
    }
}
