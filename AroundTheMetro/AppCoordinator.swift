//
//  AppCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit
import FirebaseAuth
class AppCoordinator {
    let window: UIWindow
    private var mainCoordinator: MainCoordinator?
    private var onBoardingCoordinator: OnBoardingCoordinator?

    private var appContext: AppContext

    // MARK: -

    init(with window: UIWindow, context: AppContext) {
        self.window = window
        self.appContext = context
    }

    func start() {
        Appearance.setup()
//		navigateToLogin()
//		navigateToHome()

		navigateToHome()
        if appContext.userStorageService.isFirstLaunch {
            appContext.userStorageService.isFirstLaunch = false

			let subscription = Storyboard.Subscription.sunscriptionVC
			router.present(subscription, animated: true, completion: nil)
//            onBoardingCoordinator = OnBoardingCoordinator(with: router, context: appContext)
//            onBoardingCoordinator?.onComplete = { isFinished in
//                router.presentedViewController?.dismiss(animated: true)
//            }
//            onBoardingCoordinator?.start()
		}
//		else if Auth.auth().currentUser == nil {
//			navigateToLogin()
//		}else {

//		}
    }

	let router = UINavigationController()
	private func navigateToHome() {

		router.setNavigationBarHidden(true, animated: false)

		let adsControllerContainer = AdsContainerViewController()
		adsControllerContainer.contentViewController = router

		appContext.ads.setAdsContainer(adsControllerContainer)

		window.rootViewController = adsControllerContainer

		mainCoordinator = MainCoordinator(with: router, context: appContext)
		mainCoordinator?.start()
	}

//	private func navigateToLogin() {
//		window.rootViewController = router
//		guard let login = UIStoryboard(name: "Auth", bundle: .main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {return}
//		login.showHome = { [weak self] in
//			self?.navigateToHome()
//		}
//		router.setViewControllers([login], animated: false)
//	}
}
