//
//  MenuCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit
class MenuCoordinator {
    var onHome: (() -> Void)?
    var onChangeCity: (() -> Void)?
    var onContactUs: (() -> Void)?
    
    private var router: UINavigationController

    init(with router: UINavigationController) {
        self.router = router
    }

    func start() {
        let viewController = Storyboard.Menu.menuVC
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
        router.setViewControllers([viewController], animated: false)
    }
}
