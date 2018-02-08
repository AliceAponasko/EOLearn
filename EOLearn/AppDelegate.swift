//
//  AppDelegate.swift
//  EOLearn
//
//  Created by Alice Aponasko on 2/4/18.
//  Copyright © 2018 aliceaponasko. All rights reserved.
//

import UIKit
import XCGLogger

let log = XCGLogger.default

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let userDefaults = UserDefaults.standard

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        log.setup(
            level: .debug,
            showThreadName: true,
            showLevel: true,
            showFileNames: true,
            showLineNumbers: true,
            writeToFile: nil,
            fileLevel: nil)

        if userDefaults.authToken() != nil {
            navigateToCoursePage()
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

    // MARK: Helpers

    private func navigateToCoursePage() {
        guard let rootNavigationController = window?.rootViewController
            as? UINavigationController else {
                return
        }

        let viewControllers = NSMutableArray(
            array: rootNavigationController.viewControllers)

        for viewController in viewControllers
            where viewController is CoursesViewCotroller {
                let coursesVC = viewController

                let coursesVCIndex = viewControllers.index(of: coursesVC)
                let range = NSRange(location: 0, length: coursesVCIndex + 1)
                let stackVC = viewControllers.subarray(with: range)

                if let modifiedViewControllers = stackVC as? [UIViewController] {
                    rootNavigationController.viewControllers = modifiedViewControllers
                }

                return
        }

        let storyboard = UIStoryboard(
            name: Const.General.storyboardId,
            bundle: nil)

        let coursesVC = storyboard.instantiateViewController(
            withIdentifier: Const.Courses.viewControllerId)

        rootNavigationController.pushViewController(
            coursesVC,
            animated: false)
    }
}
