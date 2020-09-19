//
//  BaseCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation

class BaseCoordinator: NSObject, CoordinatorType {
    var initialContainer: ContainerType?
    var router: RouterType
    var childCoordinators: [CoordinatorType] = []
    var onComplete: ((Bool) -> Void)?

    func start() { }

    init(with router: RouterType) {
        self.router = router
    }
}
