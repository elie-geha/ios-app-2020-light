//
//  Place.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

enum PlaceType {
    case restoraunt
    case boutique
    case beautyAndHealth
    case attraction
}

struct Place {
    let name: String
    let placeType: PlaceType
}
