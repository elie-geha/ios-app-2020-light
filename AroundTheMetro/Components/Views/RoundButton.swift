//
//  RoundButton.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.layer.cornerRadius = min(bounds.height, bounds.width) / 2
        self.layer.masksToBounds = true
    }
}
