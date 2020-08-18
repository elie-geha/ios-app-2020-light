//
//  Place.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

enum PlaceType: String, Codable {
    case restoraunt = "Restaurant"
    case boutique = "Boutique"
    case beautyAndHealth = "Beauty & Health"
    case attraction = "Attraction"

    var apiValue: String {
        switch self {
        case .restoraunt: return "Restaurants"
        case .boutique: return "Boutiques"
        case .beautyAndHealth: return "BeautyHealths"
        case .attraction: return "Attractions"
        }
    }
}

struct Place: Codable {
    let name: String
    let placeType: PlaceType
    let imageName: String

    var imageURL: String?

    enum CodingKeys: String, CodingKey {
        case name
        case placeType = "type"
        case imageName = "imagename"
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
