//
//  IntegrationSpecs.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 20.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

protocol Integration {}

protocol AnalyticsIntegrationType: Integration {
    func trackEvent(with type: AnalyticsEventType)
}

protocol AdsContainer: UIViewController {
    func setBannerView(_ bannerView: UIView)
    func removeBannerView()
    func hideBanner()
    func resizeBanner(to height: CGFloat)

    var onResized: ((CGSize) -> Void)? { get set }
}

protocol AdsIntegrationType: Integration {
    func setAdsContainer(_ adsContainer: AdsContainer?)
    func handleEvent(with type: AdsEventType)
}

struct AuthUserInfo {
    var displayName: String?
    var email: String?
    var photoURL: URL?
    var anonimous: Bool = false
}

enum AuthError: Error {
    case loginError(String)
    case alreadyLoggedIn
    case logoutError
}

protocol AuthIntegrationType: Integration {
    var isAuthorized: Bool { get }
    var userInfo: AuthUserInfo? { get }

    func login(with email: String, password: String, completion: ((Result<AuthUserInfo?, AuthError>) -> Void)?)
    func register(with email: String, password: String, completion: ((Result<AuthUserInfo?, AuthError>) -> Void)?)
    func logout(completion: ((Error?) -> Void)?)

    func appleSignIn(with idTokenString: String,
                     nonce: String,
                     completion: ((Result<AuthUserInfo?, AuthError>) -> Void)?)

    func googleSignIn(with idTokenString: String,
                      accessToken: String,
                      completion: ((Result<AuthUserInfo?, AuthError>) -> Void)?)

    func facebookSignIn(with token: String,
                        completion: ((Result<AuthUserInfo?, AuthError>) -> Void)?)
}

enum ThirdPartyAuthError: Error {
    case completedWithError(String)
    case cancelled
    case failed(String)
}

protocol ThirdPartyAuthIntegrationType { }

protocol AppleAuthIntegrationType: ThirdPartyAuthIntegrationType {
    func signIn(in window: UIWindow?,
                completion: ((Result<(token: String, nonce: String), ThirdPartyAuthError>) -> Void)?)
}

protocol GoogleAuthIntegrationType: ThirdPartyAuthIntegrationType {
    func signIn(in viewController: UIViewController?,
                completion: ((Result<(token: String, accessToken: String), ThirdPartyAuthError>) -> Void)?)
}

protocol FacebookAuthIntegrationType: ThirdPartyAuthIntegrationType {
    func signIn(in viewController: UIViewController?,
                completion: ((Result<String, ThirdPartyAuthError>) -> Void)?)
}


