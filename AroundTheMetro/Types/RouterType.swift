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
    func present(container: ContainerType, animated: Bool)
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

    func present(container: ContainerType, animated: Bool) {
        guard let controller = container.asUIViewController() else { return }
        present(controller, animated: animated)
    }

    func hide(container: ContainerType, animated: Bool = true) {
        guard let controller = container.asUIViewController() else { return }

        if let navigationController = self as? UINavigationController, presentedViewController != controller {
            if let indexOfController = navigationController.viewControllers.firstIndex(of: controller),
                indexOfController > 0 {
                let previousController = navigationController.viewControllers[indexOfController - 1]
                navigationController.popToViewController(previousController, animated: animated)
            } else {
                navigationController.popViewController(animated: animated)
            }
        } else {
            controller.dismiss(animated: animated, completion: nil)
        }
    }
}
