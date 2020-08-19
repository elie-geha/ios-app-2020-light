//
//  HomeCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

class HomeCoordinator {
    var onShare: (() -> Void)?
    var onMenu: (() -> Void)?

    private var router: UINavigationController
    private var context: AppContext

    init(with router: UINavigationController, context: AppContext) {
        self.router = router
        self.context = context
    }

    func start() {
        let viewController = Storyboard.homeVC
        viewController.title = context.userStorageService.currentCity
        viewController.onLeftBarButton = onMenu
        viewController.onRightBarButton = onShare
        router.setViewControllers([viewController], animated: false)
    }
}
