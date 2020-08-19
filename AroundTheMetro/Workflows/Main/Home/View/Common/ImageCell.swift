//
//  BannerCell.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Kingfisher
import UIKit

class ImageCell: UICollectionViewCell {
    static let identifier: String = "ImageCell"
    static let nib = UINib(nibName: "ImageCell", bundle: nil)

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.isHidden = true
        }
    }

    var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.isHidden = title == nil
        }
    }
}
