//
//  MetroLocationsService.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation

class MetroLocationsService: LocalStorageService {
    var parsedStations = [String: [MetroStationLocation]]()

    func stations(for city: String) -> [MetroStationLocation] {
        guard let cachedStations = parsedStations[city] else {
            let stations = parseStations(for: city)
            parsedStations[city] = stations
            return stations
        }

        return cachedStations
    }

    private func parseStations(for city: String) -> [MetroStationLocation] {
        guard let pathToCity = Bundle.main.path(forResource: city, ofType: "plist"),
            let cityData = FileManager.default.contents(atPath: pathToCity) else { return [] }

        do {
            let stations = try PropertyListDecoder().decode(Stations.self, from: cityData)
            return stations.stations
        } catch {
            print("Error reading plist: \(error)")
            return []
        }
    }
}

fileprivate struct Stations: Codable {
    let stations: [MetroStationLocation]
}
