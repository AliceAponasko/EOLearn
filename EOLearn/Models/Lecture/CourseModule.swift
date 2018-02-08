//
//  CourseModule.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/7/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation

struct CourseModule: Codable, Equatable {

    // MARK: Coder Key

    enum Keys: String, CodingKey {
        case id = "course_module_id"
        case title
        case segments
    }

    // MARK: Properties

    var id: Int
    var title: String
    var segments: [CourseModuleSegment]
}

extension CourseModule {

    // MARK: Decode

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Keys.self)
        let id = try values.decode(Int.self, forKey: .id)
        let title = try values.decode(String.self, forKey: .title)

        var segmentsArray = try values.nestedUnkeyedContainer(forKey: .segments)
        var segments: [CourseModuleSegment] = []
        while !segmentsArray.isAtEnd {
            let segment = try segmentsArray.decode(CourseModuleSegment.self)
            segments.append(segment)
        }

        self.init(
            id: id,
            title: title,
            segments: segments)
    }

    // MARK: Encode

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(segments, forKey: .segments)
    }
}

func == (lhs: CourseModule, rhs: CourseModule) -> Bool {
    return lhs.id == rhs.id
}
