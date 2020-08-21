//
//  Storyboard.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

protocol StoryboardType {
    static var name: String { get }
    static var storyboard: UIStoryboard { get }
}

extension StoryboardType {
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
}

enum Storyboard {
    enum Home: StoryboardType {
        static let name = "Home"

        static let homeVC = storyboard.instantiateInitialViewController() as! HomeViewController
        static let placesVC = storyboard.instantiateViewController(identifier: "PlacesViewController") as! PlacesViewController

        static let allPlacesListVC = storyboard.instantiateViewController(identifier: "AllPlacesListViewController") as! AllPlacesListViewController
        static let metroListVC = storyboard.instantiateViewController(identifier: "MetroListViewController") as! MetroListViewController
    }

    enum Menu: StoryboardType {
        static let name = "Menu"

        static let menuVC = storyboard.instantiateInitialViewController() as! MenuViewController
    }
}
