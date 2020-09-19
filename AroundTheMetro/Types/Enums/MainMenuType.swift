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
    case login
    case profile

    var iconName: String {
        switch self {
        case .home: return "home-icon"
        case .changeCity: return "city-icon"
        case .contactUs: return "contactus-icon"
        case .login: return "login"
        case .profile: return "profile"
        }
    }

    var title: String {
        switch self {
        case .home: return "Home".localized
        case .changeCity: return "Change City".localized
        case .contactUs: return "Contact us".localized
        case .login: return "Login".localized
        case .profile: return "Profile".localized
        }
    }
}
