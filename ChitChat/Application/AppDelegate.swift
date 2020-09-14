//
//  AppDelegate.swift
//  ChitChat
//
//  Created by ty foskey on 9/8/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let router = Router(navigationController: UINavigationController())
    private lazy var applicationCoordinator = self.makeCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         FirebaseApp.configure()
         
         window = UIWindow(frame: UIScreen.main.bounds)
         let loginView = UIViewController()
         loginView.view.backgroundColor = .red
         window?.rootViewController = loginView//applicationCoordinator.router.toPresent()
        // self.window = window
         window?.makeKeyAndVisible()
        return true
    }

    private func makeCoordinator() -> AppCoordinator {
        return AppCoordinator(router: router)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

