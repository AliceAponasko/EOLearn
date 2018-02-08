//
//  CourseModuleSegment.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/7/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation

struct CourseModuleSegment: Codable, Equatable {

    // MARK: Coder Key

    enum Keys: String, CodingKey {
        case id
        case type
        case name
    }

    // MARK: Properties

    var id: Int
    var type: String
    var name: String
}

extension CourseModuleSegment {

    // MARK: Decode

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Keys.self)
        let id = try values.decode(Int.self, forKey: .id)
        let name = try values.decode(String.self, forKey: .name)
        let type = try values.decode(String.self, forKey: .type)

        self.init(id: id, type: type, name: name)
    }

    // MARK: Encode

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
    }
}

func == (lhs: CourseModuleSegment, rhs: CourseModuleSegment) -> Bool {
    return lhs.id == rhs.id
}
