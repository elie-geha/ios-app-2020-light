//
//  City.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

struct City: Hashable {
    let name: String
    let plistName: String?
    let metroPlanImage: UIImage

    init(name: String, plistName: String? = nil, metroPlanImage: UIImage) {
        self.name = name
        self.plistName = plistName
        self.metroPlanImage = metroPlanImage
    }
}
