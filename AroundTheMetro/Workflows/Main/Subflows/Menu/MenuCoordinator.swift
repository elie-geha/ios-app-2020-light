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

    var onHome: (() -> Void)?
    var onChangeCity: (() -> Void)?
    var onContactUs: (() -> Void)?


    init(with router: RouterType) {
        self.router = router
    }

    func start() {
        let viewController = Storyboard.Menu.menuVC
        initialContainer = viewController
        viewController.menuItems = [
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
