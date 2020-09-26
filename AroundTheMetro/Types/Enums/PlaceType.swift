//
//  PlaceType.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 26.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

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

    var defaultImage: UIImage {
        switch self {
            case .restoraunt: return UIImage(named: "resto-listicon")!
            case .boutique: return UIImage(named: "boutique-listicon")!
            case .beautyAndHealth: return UIImage(named: "salon-iconlist")!
            case .attraction: return UIImage(named: "attraction-iconlist")!
        }
    }
}
