//  
//  AuthorizationCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 10.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

public final class AuthorizationCoordinator: CoordinatorType {
    var router: RouterType
    var initialContainer: ContainerType?
    var onComplete: ((Bool) -> Void)?

    // MARK: -

    init(with router: RouterType) {
        self.router = router
    }

    func start() {
        let authorizationCoordinatorVC = Storyboard.Authorization.authorizationVC
        initialContainer = authorizationCoordinatorVC
        router.show(container: authorizationCoordinatorVC, animated: true)
    }
}
