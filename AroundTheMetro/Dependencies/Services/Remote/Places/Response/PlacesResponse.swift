//
//  PlacesResponse.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation

struct PlacesResponse: Codable {
    let places: [Place]
    let logoURL: String
    let coverPhotoURL: String

    enum CodingKeys: String, CodingKey {
        case places
        case logoURL = "download_prefix_store"
        case coverPhotoURL = "download_prefix_store_coverphoto"
    }
}
