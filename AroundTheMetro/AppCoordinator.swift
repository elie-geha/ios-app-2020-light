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

    private var appContext: AppContext

    // MARK: -

    init(with window: UIWindow, context: AppContext) {
        self.window = window
        self.appContext = context
    }

    func start() {
        let router = UINavigationController()
        router.setNavigationBarHidden(true, animated: false)
        window.rootViewController = router
        mainCoordinator = MainCoordinator(with: router, context: appContext)
        mainCoordinator?.start()
    }
}
