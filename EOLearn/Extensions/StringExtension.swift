//
//  StringExtension.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/6/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation

extension String {

    func trim() -> String {
        return self.trimmingCharacters(
            in: CharacterSet.whitespaces)
    }
}
