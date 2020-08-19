//
//  MetroStation.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

struct MetroStation: Codable {
    var name: String

    enum CodingKeys: String, CodingKey {
        case name = "metro_name"
    }
}
