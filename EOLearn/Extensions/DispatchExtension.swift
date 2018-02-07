//
//  DispatchExtension.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/6/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation

public func mainQueue(block: @escaping () -> Void) {
    DispatchQueue.main.async {
        block()
    }
}
