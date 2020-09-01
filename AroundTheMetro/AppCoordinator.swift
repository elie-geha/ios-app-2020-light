//
//  AppCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

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

        let router = UINavigationController()
        router.setNavigationBarHidden(true, animated: false)

        let adsControllerContainer = AdsContainerViewController()
        adsControllerContainer.contentViewController = router

        appContext.ads.setAdsContainer(adsControllerContainer)

        window.rootViewController = adsControllerContainer

        mainCoordinator = MainCoordinator(with: router, context: appContext)
        mainCoordinator?.start()

        if true {
            onBoardingCoordinator = OnBoardingCoordinator(with: router, context: appContext)
            onBoardingCoordinator?.onComplete = {

            }
            onBoardingCoordinator?.start()
        }
    }
}
