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

    func getPlaces(with type: PlaceType, country: String, city: String, with result: ((Result<[Place], Error>) -> Void)?) {
        placesService.fetchPlaces(with: type, country: country, city: city, with: { fetchResult in
            switch fetchResult {
            case .success(let response):
                let places: [Place] = response.places.map {
                    var place = $0
                    place.imageURL = response.logoURL + $0.imageName
                    return place
                }
                result?(.success(places))
            case .failure(let error):
                result?(.failure(error))
            }
        })
    }
}
