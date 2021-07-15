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
    var onLogin: (() -> Void)?

    private var router: UINavigationController

    init(with router: UINavigationController) {
        self.router = router
    }


    func start() {
        let viewController = Storyboard.Menu.menuVC
		let item: MainMenuItem
		if Auth.auth().currentUser == nil {
			item = MainMenuItem(type: .login, onSelect: { [weak self] in
				self?.onLogin?()
			})
		}else {
			item = MainMenuItem(type: .profile, onSelect: { [weak self] in
				self?.onProfile?()
			})
		}
		let items = [
			item,
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

        viewController.menuItems = items
		viewController.showSubscriptionScene = { [weak self] in
			self?.onSubscription?()
		}
		viewController.showProfileScene = { [weak self] in
			self?.onProfile?()
		}
		viewController.showLoginScene = { [weak self] in
			self?.onLogin?()
		}

        router.setViewControllers([viewController], animated: false)
    }
}
