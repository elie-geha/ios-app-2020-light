//
//  Banner.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

struct Banner: Codable {
    let image: String

    enum CodingKeys: String, CodingKey {
        case image = "imagename"
    }
}
