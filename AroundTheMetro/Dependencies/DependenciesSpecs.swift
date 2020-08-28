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
    func showBanner()
    func hideBanner()
}

protocol AdsIntegrationType: Integration {
    func setAdsContainer(_ adsContainer: AdsContainer?)
    func handleEvent(with type: AdsEventType)
}
