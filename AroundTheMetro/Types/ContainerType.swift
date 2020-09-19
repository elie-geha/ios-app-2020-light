//
//  ContainerType.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 10.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

protocol ContainerType {
    func asUIViewController() -> UIViewController?
}

extension UIViewController: ContainerType {
    func asUIViewController() -> UIViewController? {
        return self
    }
}
