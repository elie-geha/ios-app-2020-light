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
    let metroPlanImageUrl: String

    init(name: String, plistName: String? = nil, metroPlanImageUrl: String) {
        self.name = name
        self.plistName = plistName
        self.metroPlanImageUrl = metroPlanImageUrl
    }
}
