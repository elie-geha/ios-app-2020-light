//
//  DependenciesSpecs.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

// MARK: - Services

import UIKit

protocol Service {}

protocol APIService: Service {}
protocol LocalStorageService: Service {}

protocol BannersAPIService: APIService {
    func fetchBanners(country: Country, city: City, with result: ((Result<BannersResponse, Error>) -> Void)?)
}

// TODO: other services

// MARK: - Repositories

protocol Repository {}

protocol BannersRepositoryType {
    var bannersService: BannersAPIService { get }

    func getBanners(country: Country, city: City, with result: ((Result<[Banner], Error>) -> Void)?)
}

// TODO: other repos

// MARK: - Integrations

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
}

protocol AppleAuthIntegrationType: Integration {
    func signIn(in window: UIWindow?,
                completion: ((Result<(token: String, nonce: String), Error>) -> Void)?)
}

protocol GoogleAuthIntegrationType: Integration {
    func signIn(in viewController: UIViewController?,
                completion: ((Result<(token: String, accessToken: String), Error>) -> Void)?)
}

