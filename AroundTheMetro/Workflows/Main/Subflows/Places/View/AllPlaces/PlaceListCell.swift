//
//  PlaceListCell.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 22.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Kingfisher
import UIKit

class PlaceListCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    func configure(with place: Place) {

        if let imageURL = place.imageURL {
            iconView.kf.setImage(with: imageURL)
        }

        titleLabel.text = place.name
        categoryLabel.text = place.placeType.rawValue
    }
}
