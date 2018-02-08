//
//  LectureSegmentRequest.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/7/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation

enum LectureSegmentResult {
    case success(LectureSegment)
    case failure(ApiError)
}

extension APIClient {

    // MARK: Lecture segment by id

    func lectureSegment(
        lectureSegmentId: Int,
        courseId: Int,
        sender: Loading?,
        completion: @escaping ((LectureSegmentResult) -> Void)) {

        if let sender = sender {
            if sender.isLoading {
                return
            }
        }

        sender?.startLoading()

        get(
            "\(Api.Endpoint.course)\(courseId)" +
            "\(Api.Endpoint.lectureSegment)\(lectureSegmentId)",
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
                        log.error("Failed to fetch lecture segment \(lectureSegmentId)")

                        completion(.failure(error))

                    }
                }
        }
    }

    private func parse(_ data: Data) -> LectureSegmentResult {
        let decoder = JSONDecoder()
        do {
            let lecture = try decoder.decode(LectureSegment.self, from: data)

            log.info("Lecture \(lecture.id) is successfully fetched")

            return .success(lecture)
        } catch {
            log.error("Failed to parse lecture from json: " +
                "\(String(describing: try? JSONSerialization.jsonObject(with: data, options: [])))")
            return .failure(.general)
        }
    }
}
