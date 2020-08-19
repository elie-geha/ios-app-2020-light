//
//  MetroLocationsRepository.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

class MetroLocationsRepository: Repository {
    var metroLocationsService: MetroLocationsService

    init(metroLocationsService: MetroLocationsService) {
        self.metroLocationsService = metroLocationsService
    }

    func getMetroLocations(country: String, city: String,
                           with result: ((Result<[MetroStationLocation], Error>) -> Void)?) {
        result?(.success(metroLocationsService.stations(for: city)))
    }
}
