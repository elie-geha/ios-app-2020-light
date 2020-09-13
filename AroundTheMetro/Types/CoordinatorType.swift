//
//  CoordinatorType.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 01.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

protocol CoordinatorType {
    var router: RouterType { get }
    var initialContainer: ContainerType? { get }
    var onComplete: ((_ success: Bool) -> Void)? { get set }

    func start()
    func finish()
    func restart()
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
}
