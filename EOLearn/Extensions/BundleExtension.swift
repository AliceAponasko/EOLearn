//
//  BundleExtension.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/6/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import Foundation

extension Bundle {

    private struct BundleKey {
        static let apiURL = "ExeconlineAPI"
        static let apiToken = "ExeconlineAPIToken"
    }

    private class func mainBundle() -> [String: AnyObject]? {
        return Bundle.main.infoDictionary as [String: AnyObject]?
    }

    class func apiURL() -> String {
        guard let bundle = mainBundle() else {
            return ""
        }

        if let apiURL = bundle[BundleKey.apiURL] as? String {
            log.debug("API URL = \(apiURL)")
            return apiURL
        } else {
            log.error("API URL not found")
            return ""
        }
    }

    class func apiToken() -> String {
        guard let bundle = mainBundle() else {
            return ""
        }

        if let token = bundle[BundleKey.apiToken] as? String {
            log.debug("API token = \(token)")
            return token
        } else {
            log.error("API token not found")
            return ""
        }
    }
}
