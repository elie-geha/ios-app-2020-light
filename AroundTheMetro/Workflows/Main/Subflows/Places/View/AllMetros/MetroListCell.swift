//
//  MetroListCell.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 22.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Kingfisher
import UIKit

class MetroListCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func configure(with metro: MetroStation) {

        iconView.image = UIImage(named: "metro-green")
        titleLabel.text = metro.name
    }
}

