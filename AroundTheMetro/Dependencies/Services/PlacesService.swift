//
//  PlacesServiceRemote.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

class PlacesServiceRemote: APIService {
    func fetchPlaces(with type: PlaceType, with result: ((Result<[Place], Error>) -> Void)?) {
        let places = [Place]()
        result?(.success(places))
    }
}
