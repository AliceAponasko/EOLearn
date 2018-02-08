//
//  LectureSegment.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/7/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation

struct LectureSegment: Codable {

    // MARK: Coder Key

    enum Keys: String, CodingKey {
        case id
        case slideShowUrl = "slide_show"
    }

    // MARK: Properties

    var id: Int
    var slideShowUrl: String
}

extension LectureSegment {

    // MARK: Decode

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Keys.self)
        let id = try values.decode(Int.self, forKey: .id)
        let slideShowUrl = try values.decode(String.self, forKey: .slideShowUrl)

        self.init(id: id, slideShowUrl: slideShowUrl)
    }

    // MARK: Encode

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(id, forKey: .id)
        try container.encode(slideShowUrl, forKey: .slideShowUrl)
    }
}

func == (lhs: LectureSegment, rhs: LectureSegment) -> Bool {
    return lhs.id == rhs.id
}
