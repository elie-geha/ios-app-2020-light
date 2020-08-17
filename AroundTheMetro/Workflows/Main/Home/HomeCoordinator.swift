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

    init(with router: UINavigationController) {
        self.router = router
    }

    func start() {
        let viewController = UIViewController()
        router.setViewControllers([viewController], animated: false)
    }
}
