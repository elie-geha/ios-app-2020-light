//
//  AppDelegate.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import FacebookCore
import Firebase
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
		verifySubscription()
        return true
    }

	private func verifySubscription() {
		IAPManager.shared.startObserving()

		//check if subscription is still valid
//		ControlSettings.shouldShowAddMobBanner = !IAPManager.shared.isSubscribed

		guard IAPManager.shared.isSubscribed else {return}

		switch IAPManager.shared.verify(transactionIdentifier: "") {
		case .success(_):
			break
		case .failure(let error):
			guard let iapError  = error as? IAPManager.IAPManagerError else {break}
			switch iapError {
			case .subscriptionExpired:
				//					self.updateSubscriptionStatus()
				//remove subscription
				IAPManager.shared.productID = ""
//				ControlSettings.shouldShowAddMobBanner = true
				break
			default:
				break
			}
		}
	}


    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    private func setupIntegrations(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // MARK: - Firebase config
        FirebaseApp.configure()

        //MARK: - FACEBOOK SDK CONFIGURATION
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

