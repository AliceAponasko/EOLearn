//
//  Course.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/7/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation

struct Course: Codable, Equatable {

    // MARK: Coder Key

    enum Keys: String, CodingKey {
        case id = "course_id"
        case title
        case modules = "course_modules"
    }

    // MARK: Properties

    var id: Int
    var title: String
    var modules: [CourseModule]
}

extension Course {

    // MARK: Decode

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Keys.self)
        let id = try values.decode(Int.self, forKey: .id)
        let title = try values.decode(String.self, forKey: .title)

        var modulesArray = try values.nestedUnkeyedContainer(forKey: .modules)
        var modules: [CourseModule] = []
        while !modulesArray.isAtEnd {
            let module = try modulesArray.decode(CourseModule.self)
            modules.append(module)
        }

        self.init(
            id: id,
            title: title,
            modules: modules)
    }

    // MARK: Encode

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(modules, forKey: .modules)
    }
}

func == (lhs: Course, rhs: Course) -> Bool {
    return lhs.id == rhs.id
}
