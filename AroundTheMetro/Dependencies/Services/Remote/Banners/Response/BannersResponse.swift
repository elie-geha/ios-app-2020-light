//
//  BannersResponse.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation

struct BannersResponse: Codable {
    let banners: [Banner]

    enum CodingKeys: String, CodingKey {
        case banners = "bannerimages"
    }
}
