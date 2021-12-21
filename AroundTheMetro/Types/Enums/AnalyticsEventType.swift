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
	case clickMonthly(id: String, value: String)
	case clickYearly(id: String, value: String)
	case clickLifeTime(id: String, value: String)
	case purchasedMonthly(id: String, value: String)
	case purchasedYearly(id: String, value: String)
	case purchasedLifeTime(id: String, value: String)
    case jobsClicked
    case jobDetailsClicked
    
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
		case .clickMonthly(_,_): return "click_monthly"
		case .clickYearly(_,_): return "click_yearly"
		case .clickLifeTime(_,_): return "click_lifetime"
		case .purchasedMonthly(_, _): return "purchased_monthly"
		case .purchasedYearly(_,_): return "purchased_yearly"
		case .purchasedLifeTime(_,_): return "purchased_lifetime"
        case .jobsClicked: return "jobs_clicked"
        case .jobDetailsClicked: return "job_details_clicked"
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
		case .clickMonthly(let id, let value):
			return ["id":id,"value":value]
		case .clickYearly(let id, let value):
			return["id":id, "value":value]
		case .clickLifeTime(let id, let value):
			return ["id":id, "value":value]
		case .purchasedMonthly(let id, let value):
			return ["id":id, "value":value]
		case .purchasedYearly(let id, let value):
			return ["id":id, "value": value]
		case .purchasedLifeTime(let id, let value):
			return ["id":id, "value":value]
        case .jobsClicked:
            return [:]
        case .jobDetailsClicked:
            return [:]
        }
    }
}
