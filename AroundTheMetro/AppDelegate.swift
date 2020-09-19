//
//  AppDelegate.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import FacebookCore
import Firebase
import IQKeyboardManagerSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupIntegrations(application: application, launchOptions: launchOptions)

        if #available(iOS 13, *) {
            // do nothing, scenes available, SceneDelegate will start the app
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.makeKeyAndVisible()
            self.window = window

            appCoordinator = AppCoordinator(with: window, context: AppContext())
            appCoordinator?.start()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    private func setupIntegrations(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        AppEvents.activateApp()
        
        IQKeyboardManager.shared.enable = true
        
        // MARK: - Firebase config
        FirebaseApp.configure()

        //MARK: - FACEBOOK SDK CONFIGURATION
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

