//
//  AnalyticsEventType.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 28.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

enum AnalyticsEventType {
    case detailsPageView(String)
    case websiteClicked(String, String)
    case callClicked(String, String)
	case login(email: String)
	case signup(email: String)
	case facebookLogin
	case googleLogin
	case appleLogin

    var eventName: String {
        switch self {
        case .detailsPageView: return "place_page_view"
        case .websiteClicked: return "website_clicked"
        case .callClicked: return "call_placed"
		case .login(_): return "login"
		case .signup(_): return "signup"
		case.facebookLogin: return "facebook_login"
		case .googleLogin: return "google_login"
		case .appleLogin: return "apple_login"
        }
    }

    var params: [String : Any] {
        switch self {
        case .detailsPageView(let place):
            return ["place": place]
        case .websiteClicked(let place, let website):
            return [
                "place": place,
                "url": website
            ]
        case .callClicked(let place, let phoneNumber):
            return [
            "place": place,
            "phoneNumber": phoneNumber
        ]
		case .login(let email):
			return ["email":email]
		case .signup(let email):
			return ["email":email]
		case .facebookLogin:
			return [:]
		case .googleLogin:
			return [:]
		case .appleLogin:
			return [:]
        }
    }
}
