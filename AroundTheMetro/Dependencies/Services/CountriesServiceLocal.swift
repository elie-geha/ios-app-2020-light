//
//  CountriesServiceLocal.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation

class CountriesServiceLocal: LocalStorageService {

    lazy var allCountries: [Country] = {
        [
            Country(name: "Austria", cities: ["Vienna"].map(createCity)),
            Country(name: "Canada", cities: ["Montreal", "Toronto", "Vancouver"].map(createCity)),
            Country(name: "Emirates", cities: ["Dubai"].map(createCity)),
            Country(name: "France", cities: ["Paris", "Marseille", "Lyon", "Toulouse"].map(createCity)),
            Country(name: "India", cities: ["Delhi", "Kolkata", "Mumbai"].map(createCity)),
            Country(name: "Italy", cities: ["Rome", "Milan"].map(createCity)),
            Country(name: "Japan", cities: ["Tokyo", "Osaka", "Yokohama", "Nagoya"].map(createCity)),
            Country(name: "S_Korea", cities: ["Seoul", "Busan"].map(createCity)),
            Country(name: "Spain", cities: ["Barcelona", "Madrid", "Bilbao"].map(createCity)),
            Country(name: "Sweden", cities: ["Stockholm"].map(createCity)),
            Country(name: "Switzerland", cities: ["Lausanne"].map(createCity)),
            Country(name: "Taiwan", cities: ["Taipei"].map(createCity)),
            Country(name: "Turkey", cities: ["Istanbul"].map(createCity)),
            Country(name: "UK", cities: ["London", "Glasgow"].map(createCity)),
            Country(name: "USA", cities: ["New_York_City", "Miami", "Chicago","Atlanta"].map(createCity))
        ]
    }()

    private func createCity(with name: String) -> City {
        #warning("parse stations")
        return City(name: name, metroStations: [])
    }
}
