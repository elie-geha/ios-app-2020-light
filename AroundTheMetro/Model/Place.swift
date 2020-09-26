//
//  Place.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

struct Place: Codable {
    let metroID: String
    let metroName: String
    let name: String
    let placeType: PlaceType
    let imageName: String
    let phoneNumber: String?
    let mallName: String?
    let website: String?

    var imageURL: URL?

    enum CodingKeys: String, CodingKey {
        case metroID = "metro_ID"
        case metroName = "metroname"
        case name
        case placeType = "type"
        case imageName = "imagename"
        case phoneNumber = "contact"
        case mallName = "mallname"
        case website
    }
}

/*
 {
     "key": "2153",
     "name_en": "Domino's Pizza",
     "metroname": "Guy-Concordia",
     "type_en": "Restaurant",
     "metro_ID": "Canada_Montreal_17",
     "featured": "1",
     "imagename": "dominospizza.jpg",
     "coverphoto_filename": "resto.jpg",
     "claimed": "0",
     "contact": "5143989898",
     "website": "http:\/\/pizza.dominos.ca\/Montreal-Quebec-10651",
     "name": "Domino's Pizza",
     "metro": null,
     "type": "Restaurant",
     "address": null,
     "aboutus": null
 }
 */
