//
//  MainMenuType.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 21.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

enum MainMenuType {
    case home
    case changeCity
    case contactUs

    var iconName: String {
        switch self {
        case .home: return "home-icon"
        case .changeCity: return "city-icon"
        case .contactUs: return "contactus-icon"
        }
    }

    var title: String {
        switch self {
        case .home: return "Home".localized
        case .changeCity: return "Change City".localized
        case .contactUs: return "Contact us".localized
        }
    }
}
