//
//  HomeMenuType.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

enum HomeMenuType {
    case metroPlan
    case locateMetro
    case restoraunts
    case boutiques
    case beautyAndHealth
    case attractions
	case jobsInCity(cityName: String)
//	case shareTheApp
	case appsWeLove

    var backgroundImageName: String {
        switch self {
        case .metroPlan: return "metro-back"
        case .locateMetro: return "ar-back"
        case .restoraunts: return "resto-back"
        case .boutiques: return "boutiques"
        case .beautyAndHealth: return "bh"
        case .attractions: return "attractions-back"
//        case .shareTheApp: return "shareApp"
		case .jobsInCity: return "work"//"jobs_image_background"
        case .appsWeLove: return "appsLove"
        }
    }

    var iconName: String {
        switch self {
        case .metroPlan: return "metro_icon"
        case .locateMetro: return "lm_icon"
        case .restoraunts: return "resto-icon"
        case .boutiques: return "boutique-icon"
        case .beautyAndHealth: return "beauty-icon"
        case .attractions: return "attractions-icon"
		case .jobsInCity: return "services-icon"
//        case .shareTheApp: return "share"
        case .appsWeLove: return "coins-icon"
        }
    }

    var title: String {
        switch self {
        case .metroPlan: return "Metro Plan".localized
        case .locateMetro: return "Locate Metro".localized
        case .restoraunts: return "Restaurants".localized
        case .boutiques: return "Boutiques".localized
        case .beautyAndHealth: return "Beauty & Health".localized
        case .attractions: return "Attractions".localized
//		case .shareTheApp: return "Share The\nApp".localized
		case .jobsInCity(let cityName): return "Jobs in\n\(cityName)".localized
		case .appsWeLove: return "Sharing Is\nCaring"//"Apps We\nLove".localized
        }
    }
}
