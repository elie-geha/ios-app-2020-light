//
//  MenuCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

class MenuCoordinator: CoordinatorType {
    var router: RouterType
    var initialContainer: ContainerType?
    var onComplete: ((Bool) -> Void)?

    var context: AppContext

    var onLogin: (() -> Void)?
    var onProfile: (() -> Void)?
    var onHome: (() -> Void)?
    var onChangeCity: (() -> Void)?
    var onContactUs: (() -> Void)?

    init(with router: RouterType, context: AppContext) {
        self.router = router
        self.context = context
    }

    func start() {
        let viewController = Storyboard.Menu.menuVC
        initialContainer = viewController
        viewController.menuItems = [
            MainMenuItem(
                type: context.auth.isAuthorized ? .profile : .login,
                onSelect: { [weak self] in
                    self?.context.auth.isAuthorized == true
                        ? self?.onProfile?()
                        : self?.onLogin?()
            }),
            MainMenuItem(type: .home, onSelect: { [weak self] in
                self?.onHome?()
            }),
            MainMenuItem(type: .changeCity, onSelect: { [weak self] in
                self?.onChangeCity?()
            }),
            MainMenuItem(type: .contactUs, onSelect: { [weak self] in
                self?.onContactUs?()
            })
        ]
        router.show(container: viewController, animated: false)
    }
}
