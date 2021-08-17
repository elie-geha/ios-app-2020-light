//
//  AppDelegate.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import FBSDKCoreKit
import Firebase
import UIKit
import GoogleSignIn
import IQKeyboardManagerSwift

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
		SocialLoginManager.shared.configure()
		IQKeyboardManager.shared.enable = true

		configureIronSource()
        return true
    }

	private func verifySubscription() {

		//check if subscription is still valid
//		ControlSettings.shouldShowAddMobBanner = !IAPManager.shared.isSubscribed

		guard IAPManager.shared.isSubscribed else {return}

		IAPManager.shared.startObserving()
		switch IAPManager.shared.verify(productIdentifier: IAPManager.shared.productID) {
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

	@available(iOS 9.0, *)
	func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any])-> Bool {

		let appId: String = Settings.appID ?? ""
		if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
			return ApplicationDelegate.shared.application(application, open: url, options: options)
		}
		return GIDSignIn.sharedInstance().handle(url)
	}

    private func setupIntegrations(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // MARK: - Firebase config
        FirebaseApp.configure()

		

        //MARK: - FACEBOOK SDK CONFIGURATION
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

	private func configureIronSource() {
		let ironSourceAppKey = "d3af4a95"

		IronSource.initWithAppKey(ironSourceAppKey, adUnits: [IS_REWARDED_VIDEO,IS_INTERSTITIAL,IS_OFFERWALL, IS_BANNER])

		ISIntegrationHelper.validateIntegration()
	}
}

