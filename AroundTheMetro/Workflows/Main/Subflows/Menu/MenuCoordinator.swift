//
//  MenuCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

class MenuCoordinator: BaseCoordinator {
    var context: AppContext

    var onLogin: EmptyCallback?
    var onProfile: EmptyCallback?
    var onHome: EmptyCallback?
    var onChangeCity: EmptyCallback?
    var onContactUs: EmptyCallback?

    init(with router: RouterType, context: AppContext) {
        self.context = context
        super.init(with: router)
    }

    override func start() {
        let viewController = StoryboardScene.Menu.initialScene.instantiate()
        initialContainer = viewController
        viewController.menuItems = [
            // In development
//            MainMenuItem(
//                type: context.auth.isAuthorized ? .profile : .login,
//                onSelect: { [weak self] in
//                    self?.context.auth.isAuthorized == true
//                        ? self?.onProfile?()
//                        : self?.onLogin?()
//            }),
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
