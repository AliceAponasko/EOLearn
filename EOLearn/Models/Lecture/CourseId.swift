//
//  CourseId.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/7/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation

struct CourseId: Codable, Equatable {
    var id: Int
}

func == (lhs: CourseId, rhs: CourseId) -> Bool {
    return lhs.id == rhs.id
}
