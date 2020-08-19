//
//  BannerCell.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

class BannerCell: UICollectionViewCell {
    static let identifier: String = "BannerCell"
    static let nib = UINib(nibName: "BannerCell", bundle: nil)

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}
