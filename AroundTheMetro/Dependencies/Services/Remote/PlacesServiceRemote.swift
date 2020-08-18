//
//  PlacesServiceRemote.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation

struct PlacesResponse: Codable {
    let places: [Place]
    let logoURL: String
    let coverPhotoURL: String

    enum CodingKeys: String, CodingKey {
        case places
        case logoURL = "download_prefix_store"
        case coverPhotoURL = "download_prefix_store_coverphoto"
    }
}

class PlacesServiceRemote: APIService {
    func fetchPlaces(with type: PlaceType, country: String, city: String, with result: ((Result<PlacesResponse, Error>) -> Void)?) {
        let errorHandler: (Error) -> Void = { error in
            result?(.failure(error))
        }
        let successHandler: (Data) -> Void = { responseData in
            do {
                let placesRespose = try JSONDecoder().decode(PlacesResponse.self, from: responseData)
                result?(.success(placesRespose))
            } catch(let error) {
                result?(.failure(error))
            }
        }
        NetworkAdapter.request(target: .getPlaces(type: type, country: country, city: city),
                               success: successHandler,
                               error: errorHandler,
                               failure: errorHandler)
    }
}
