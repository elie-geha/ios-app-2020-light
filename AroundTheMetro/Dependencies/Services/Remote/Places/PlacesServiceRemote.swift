//
//  PlacesServiceRemote.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation

class PlacesServiceRemote: APIService {
    func fetchPlaces(with type: PlaceType, country: Country, city: City,
                     with result: ((Result<PlacesResponse, Error>) -> Void)?) {
        let errorHandler: (Error) -> Void = { error in
            result?(.failure(error))
        }
        let successHandler: (Data) -> Void = { responseData in
            do {
                let response = try JSONDecoder().decode(PlacesResponse.self, from: responseData)
                result?(.success(response))
            } catch(let error) {
                result?(.failure(error))
            }
        }
        NetworkAdapter.request(target: .getPlaces(type: type, country: country, city: city),
                               success: successHandler,
                               error: errorHandler,
                               failure: errorHandler)
    }

    func fetchMetroStations(with type: PlaceType, country: Country, city: City,
                            with result: ((Result<MetroStationsResponse, Error>) -> Void)?) {
        let errorHandler: (Error) -> Void = { error in
            result?(.failure(error))
        }
        let successHandler: (Data) -> Void = { responseData in
            do {
                let response = try JSONDecoder().decode(MetroStationsResponse.self, from: responseData)
                result?(.success(response))
            } catch(let error) {
                result?(.failure(error))
            }
        }
        NetworkAdapter.request(target: .getMetroListForStoreAPI(type: type, country: country, city: city),
                               success: successHandler,
                               error: errorHandler,
                               failure: errorHandler)
    }
}
