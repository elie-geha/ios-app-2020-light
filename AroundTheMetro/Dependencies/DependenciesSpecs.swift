//
//  DependenciesSpecs.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

// MARK: - Services

protocol Service {}

protocol APIService: Service {}
protocol LocalStorageService: Service {}

protocol BannersAPIService: APIService {
    func fetchBanners(country: String, city: String, with result: ((Result<BannersResponse, Error>) -> Void)?)
}

// MARK: - Repositories

protocol Repository {}

protocol BannersRepositoryType {
    var bannersService: BannersAPIService { get }

    func getBanners(country: String, city: String, with result: ((Result<[Banner], Error>) -> Void)?)
}
