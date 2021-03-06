//
//  AppDelegate.swift
//  fit-checker
//
//  Created by Josef Dolezal on 12/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /// Shared database context manager
    private let contextManager = ContextManager()

    /// Shared network request controller
    private let networkController: NetworkController = {
        let contextManager = ContextManager()

        return NetworkController(contextManager: contextManager)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let window = UIWindow(frame: UIScreen.main.bounds)

        window.makeKeyAndVisible()
        window.backgroundColor = .white
        self.window = window

        NotificationCenter.default.addObserver(self, selector:
            #selector(changeRootController), name:
            .FCLoginStateChanged, object: nil)

        changeRootController()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    /// Switchs root cotnroller based on user login status
    func changeRootController() {
        guard
            let (_, _) = Keechain(service: .edux).getAccount() else
        {
            // Turn off background fetch
            UIApplication.shared.setMinimumBackgroundFetchInterval(
                UIApplicationBackgroundFetchIntervalNever)

            // Show login controller
            window?.rootViewController = LoginViewController(
                networkController: networkController)

            return
        }

        let tabBarController = UITabBarController()
        let coursesController = CoursesTableViewController(contextManager:
            contextManager, networkController: networkController)
        let settingsController = SettingsViewController(
            contextManager: contextManager)

        coursesController.tabBarItem = UITabBarItem(title: tr(.courses), image:
            nil, selectedImage: nil)
        settingsController.tabBarItem = UITabBarItem(title: tr(.settings), image:
            nil, selectedImage: nil)

        let controllers = [
            coursesController,
            settingsController
        ]

        tabBarController.viewControllers = controllers

        // Set interval for background refresh
        UIApplication.shared.setMinimumBackgroundFetchInterval(
            RefreshInterval.twentyMinutes.interval)
        window?.rootViewController = UINavigationController(rootViewController:
            tabBarController)
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard
            let account = Keechain(service: .edux).getAccount(),
            let realm = try? contextManager.createContext() else { return }

        // Try to refresh only courses with classification on Edux
        let courses: [Course] = realm.objects(Course.self)
            .filter("classificationAvailable = %@", true)
            .map({ $0 })

        let promise = networkController.loadCoursesClasification(
            courses: courses,
            student: account.username
        )

        promise.success = { completionHandler(.newData) }
        promise.failure = { completionHandler(.failed) }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
