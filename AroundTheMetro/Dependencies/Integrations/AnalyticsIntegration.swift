//
//  AnalyticsIntegration.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 28.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import FirebaseAnalytics
import FBSDKCoreKit

class AnalyticsIntegration: AnalyticsIntegrationType {
    func trackEvent(with type: AnalyticsEventType) {
        Analytics.logEvent(type.eventName, parameters: type.params)

		let name = AppEvents.Name(type.eventName)
		AppEvents.logEvent(name, parameters: type.params)
    }

	/*
	func trackAdRevenue() {
		Analytics.logEvent(
		  AnalyticsEventAdImpression,
		  parameters: [
			AnalyticsParameterAdPlatform: "MoPub",
			AnalyticsParameterAdUnitName: impressionData.adUnitName,
			AnalyticsParameterAdFormat: impressionData.adUnitFormat,
			AnalyticsParameterValue: impressionData.publisherRevenue,
			AnalyticsParameterCurrency: impressionData.currency,
			AnalyticsParameterAdSource: impressionData.networkName,
			"precision": impressionData.precision,
		  ])
	  }
	}*/
}
