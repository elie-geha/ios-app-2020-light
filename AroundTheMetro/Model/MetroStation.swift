//
//  MetroStation.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

struct MetroStation: Codable, Hashable {
    var metroID: String
    var name: String

    enum CodingKeys: String, CodingKey {
        case metroID = "metro_ID"
        case name = "metro_name"
    }
}
