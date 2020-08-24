//
//  BannersServiceRemote.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation

class BannersServiceRemote: BannersAPIService {
    func fetchBanners(country: Country, city: City, with result: ((Result<BannersResponse, Error>) -> Void)?) {
        let errorHandler: (Error) -> Void = { error in
            result?(.failure(error))
        }
        let successHandler: (Data) -> Void = { responseData in
            do {
                let response = try JSONDecoder().decode(BannersResponse.self, from: responseData)
                result?(.success(response))
            } catch(let error) {
                result?(.failure(error))
            }
        }
        NetworkAdapter.request(target: .getBannerImagesAPI(country: country, city: city),
                               success: successHandler,
                               error: errorHandler,
                               failure: errorHandler)
    }
}
