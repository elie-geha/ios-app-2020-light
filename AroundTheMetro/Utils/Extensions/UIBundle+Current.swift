//
//  UIBundle+Current.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 21.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation

extension Bundle {
    private class BundleClass {}
    public static var current: Bundle { return Bundle(for: BundleClass.self) }
}
