//
//  AppDelegate.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import FacebookCore
import FBSDKCoreKit
import Firebase
import GoogleMobileAds
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupIntegrations(application: application, launchOptions: launchOptions)
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    private func setupIntegrations(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // MARK: - Admob banner
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        //MARK: - Firebase config
        FirebaseApp.configure()

        //MARK: - FACEBOOK SDK CONFIGURATION
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

