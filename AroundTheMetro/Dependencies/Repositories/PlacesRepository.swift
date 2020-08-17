//
//  PlacesRepository.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

class PlacesRepository: Repository {
    var placesService: PlacesServiceRemote

    init(placesService: PlacesServiceRemote) {
        self.placesService = placesService
    }

    func getPlaces(with type: PlaceType, with result: ((Result<[Place], Error>) -> Void)?) {
        placesService.fetchPlaces(with: type, with: { fetchResult in
            result?(fetchResult)
        })
    }
}
