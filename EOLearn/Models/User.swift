//
//  User.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/6/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation

struct User: Codable {

    // MARK: Coder Key

    enum CoderKey: String, CodingKey {
        case id = "sf_contact_uid"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarUrl = "avatar_url"
    }

    // MARK: Properties

    var id: String
    var firstName: String
    var lastName: String
    var avatarUrl: String

    // MARK: Init

    init() {
        self.init(
            id: "",
            firstName: "",
            lastName: "",
            avatarUrl: "")
    }

    init(
        id: String,
        firstName: String,
        lastName: String,
        avatarUrl: String) {

        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.avatarUrl = avatarUrl
    }
}

func == (lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id
}
