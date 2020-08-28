//
//  AppConstants.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

enum AppConstants {
    enum API {
        static let urlBase = "http://aroundthemetro.com/api"
        static let bannerImageURL = "http://aroundthemetro.com/assets/images/BannerImages/"
    }

    enum ContactUs {
        static let recepient = "info@aroundthemetro.com"
        static let subject = "Message from Around the Metro iOS App"
    }

    enum Ads {
        static let adBannerHeight: CGFloat = 50
        static let bannerAdsUnitID = "ca-app-pub-5420876778958572/4194336391"
        static let interstitialUnitID = "ca-app-pub-3940256099942544/4411468910"
        static let applicationID = "ca-app-pub-5420876778958572~6113034677"

        static let detailsPageViewsToShowInterstitial = 5
        static let intervalBetweenInterstitialShows: TimeInterval = 5.0 * 60
    }
}
