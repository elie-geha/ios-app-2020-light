//
//  PlacesRepository.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation

enum PlacesError: Error {
    case mergeFailure
}

class PlacesRepository: Repository {
    var placesService: PlacesServiceRemote

    init(placesService: PlacesServiceRemote) {
        self.placesService = placesService
    }

    func getPlacesByMetros(with type: PlaceType,
                           country: Country, city: City,
                           with result: ((Result<[MetroStation: [Place]], Error>) -> Void)?) {

        getMetroStations(with: type, country: country, city: city) { [weak self] metrosResult in
            switch metrosResult {
            case .success(let metroStations):
                self?.getPlaces(with: type, country: country, city: city) { placesResult in
                    switch placesResult {
                    case .success(let places):
                        if let metrosAndPlaces: [MetroStation: [Place]] = self?.merge(metroStations, with: places) {
                            result?(.success(metrosAndPlaces))
                        } else {
                            result?(.failure(PlacesError.mergeFailure))
                        }
                    case .failure(let error):
                        result?(.failure(error))
                    }
                }
            case .failure(let error):
                result?(.failure(error))
            }
        }
    }

    func getPlaces(with type: PlaceType,
                   country: Country, city: City,
                   with result: ((Result<[Place], Error>) -> Void)?) {
        placesService.fetchPlaces(with: type, country: country, city: city, with: { fetchResult in
            switch fetchResult {
            case .success(let response):
                let places: [Place] = response.places.map {
                    var place = $0
                    place.imageURL = URL(string: response.logoURL + $0.imageName)
                    return place
                }
                result?(.success(places))
            case .failure(let error):
                result?(.failure(error))
            }
        })
    }

    func getMetroStations(with type: PlaceType, country: Country, city: City, with result: ((Result<[MetroStation], Error>) -> Void)?) {
        placesService.fetchMetroStations(with: type, country: country, city: city, with: { fetchResult in
            switch fetchResult {
            case .success(let response):
                result?(.success(response.metros))
            case .failure(let error):
                result?(.failure(error))
            }
        })
    }

    private func merge(_ metroStations: [MetroStation], with places: [Place]) -> [MetroStation: [Place]] {
        let placesByMetroID = Dictionary(grouping: places) { $0.metroID }
        return metroStations.reduce(into: [:]) { result, station in
            result[station] = placesByMetroID[station.metroID] ?? []
        }
    }
}
