//
//  MetroStation.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

struct MetroStation: Codable {
    var name: String? {
        return nameFromPlist ?? nameFromServer
    }

    let latitude: Double?
    let longitude: Double?

    private var nameFromPlist: String?
    private var nameFromServer: String?

    enum CodingKeys: String, CodingKey {
        case nameFromServer = "metro_name"
        case nameFromPlist = "name"
        case latitude
        case longitude
    }
}
