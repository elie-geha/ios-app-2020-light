//
//  RouterType.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 10.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

protocol RouterType: ContainerType {
    func show(container: ContainerType, animated: Bool)
    func hide(container: ContainerType, animated: Bool)
}

extension UIViewController: RouterType {
    func show(container: ContainerType, animated: Bool = true) {
        guard let controller = container.asUIViewController() else { return }

        if let navigationController = self as? UINavigationController {
            if !navigationController.viewControllers.contains(controller) {
                navigationController.pushViewController(controller, animated: animated)
            }
        } else {
            present(controller, animated: animated)
        }
    }

    func hide(container: ContainerType, animated: Bool = true) {
        guard let controller = container.asUIViewController() else { return }

        if let navigationController = self as? UINavigationController {
            navigationController.popToViewController(controller, animated: animated)
        } else {
            controller.dismiss(animated: animated, completion: nil)
        }
    }
}
