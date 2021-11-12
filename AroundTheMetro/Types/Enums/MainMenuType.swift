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
    case subscription
    case profile
	case login

    var iconName: String {
        switch self {
        case .home: return "home-icon"
        case .changeCity: return "city-icon"
        case .contactUs: return "contactus-icon"
		case .subscription:  return "global-icon"
		case .profile:  return "IconProfile"
		case .login:  return "IconProfile"
        }
    }

    var title: String {
        switch self {
        case .home: return "Home".localized
        case .changeCity: return "Change City".localized
        case .contactUs: return "Contact us".localized
        case .subscription: return "Remove Ads".localized
        case .profile: return "Profile".localized
		case .login: return "Login".localized
        }
    }
}
