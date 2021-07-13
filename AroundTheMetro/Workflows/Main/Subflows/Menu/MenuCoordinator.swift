//
//  MenuCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit
import FirebaseAuth
class MenuCoordinator: CoordinatorType {
    var onHome: (() -> Void)?
    var onChangeCity: (() -> Void)?
    var onContactUs: (() -> Void)?
    var onSubscription: (() -> Void)?
    var onProfile: (() -> Void)?

    private var router: UINavigationController

    init(with router: UINavigationController) {
        self.router = router
    }


    func start() {
        let viewController = Storyboard.Menu.menuVC
		var items = [
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

		if Auth.auth().currentUser != nil {
			items.append(MainMenuItem(type: .profile, onSelect: {
				self.onProfile?()
			}))
		}
        viewController.menuItems = items
		viewController.showSubscriptionScene = { [weak self] in
			self?.onSubscription?()
		}
		viewController.showProfileScene = { [weak self] in
			self?.onProfile?()
		}

        router.setViewControllers([viewController], animated: false)
    }
}
