//
//  OnBoardingStepType.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 01.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

enum OnBoardingStepType {
    case discover
    case locate
    case offlineMap
    case stayTuned

    var title: String {
        switch self {
        case .discover: return "onboarding.discover.title".localized
        case .locate: return "onboarding.locate.title".localized
        case .offlineMap: return "onboarding.offlineMap.title".localized
        case .stayTuned: return "onboarding.stayTuned.title".localized
        }
    }

    var titleColor: UIColor {
        let color: UIColor?

        switch self {
        case .discover: color = UIColor(hex: "#f85200")
        case .locate: color = UIColor(hex: "#3ac5d7")
        case .offlineMap: color = UIColor(hex: "#a06338")
        case .stayTuned: color = UIColor(hex: "#d70d23")
        }

        return color ?? .black
    }

    var description: String {
        switch self {
        case .discover: return "onboarding.discover.description".localized
        case .locate: return "onboarding.locate.description".localized
        case .offlineMap: return "onboarding.offlineMap.description".localized
        case .stayTuned: return "onboarding.stayTuned.description".localized
        }
    }

    var image: UIImage {
        switch self {
        case .discover: return UIImage(named: "step1-image")!
        case .locate: return UIImage(named: "step2-image")!
        case .offlineMap: return UIImage(named: "step3-image")!
        case .stayTuned: return UIImage(named: "step4-image")!
        }
    }
}
