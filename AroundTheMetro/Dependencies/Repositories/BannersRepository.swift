//
//  BannersRepository.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

class BannersRepository: BannersRepositoryType {
    var bannersService: BannersAPIService

    init(bannersService: BannersAPIService) {
        self.bannersService = bannersService
    }

    func getBanners(country: String, city: String, with result: ((Result<[Banner], Error>) -> Void)?) {
        bannersService.fetchBanners(country: country, city: city, with: { fetchResult in
            switch fetchResult {
            case .success(let response):
                result?(.success(response.banners))
            case .failure(let error):
                result?(.failure(error))
            }
        })
    }
}
