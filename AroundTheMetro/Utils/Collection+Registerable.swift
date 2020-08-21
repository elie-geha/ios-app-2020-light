//
//  Collection+Registerable.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 21.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

protocol CollectionRegisterable {
    static var nib: UINib { get }
    static var reuseID: String { get }
}

extension CollectionRegisterable where Self: UIView {
    static var reuseID: String {
        return nibName
    }
}

extension UITableViewCell: CollectionRegisterable {}
extension UICollectionViewCell: CollectionRegisterable {}

