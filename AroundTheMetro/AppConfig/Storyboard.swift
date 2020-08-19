//
//  Storyboard.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

struct Storyboard {
    static let homeVC = UIStoryboard(name: "Home", bundle: nil)
        .instantiateInitialViewController() as! HomeViewController
}
