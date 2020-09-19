//
//  CoordinatorType.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 01.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

protocol CoordinatorType: class {
    var router: RouterType { get }
    var initialContainer: ContainerType? { get }
    var childCoordinators: [CoordinatorType] { get set }

    var onComplete: ((_ success: Bool) -> Void)? { get set }

    func start()
    func finish()
    func restart()

    func addDependency(_ coordinator: CoordinatorType, autoremove: Bool)
    func removeDependency(_ coordinator: CoordinatorType?)
}

extension CoordinatorType {
    func finish() {
        if let initialContainer = initialContainer {
            router.hide(container: initialContainer, animated: true)
            onComplete?(true)
        } else {
            onComplete?(false)
        }
    }

    func restart() {
        finish()
        start()
    }

    func addDependency(_ coordinator: CoordinatorType, autoremove: Bool = true) {
        for element in childCoordinators where element === coordinator {
            return
        }
        childCoordinators.append(coordinator)
        if autoremove {
            coordinator.onComplete = { [weak self] _ in
                self?.removeDependency(coordinator)
            }
        }
    }

    func removeDependency(_ coordinator: CoordinatorType?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else { return }
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
}
