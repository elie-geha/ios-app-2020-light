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
            Country(name: "Austria", cities: ["Vienna"].map(City.init)),
            Country(name: "Canada", cities: ["Montreal", "Toronto", "Vancouver"].map(City.init)),
            Country(name: "Emirates", cities: ["Dubai"].map(City.init)),
            Country(name: "France", cities: ["Paris", "Marseille", "Lyon", "Toulouse"].map(City.init)),
            Country(name: "India", cities: ["Delhi", "Kolkata", "Mumbai"].map(City.init)),
            Country(name: "Italy", cities: ["Rome", "Milan"].map(City.init)),
            Country(name: "Japan", cities: ["Tokyo", "Osaka", "Yokohama", "Nagoya"].map(City.init)),
            Country(name: "S_Korea", cities: ["Seoul", "Busan"].map(City.init)),
            Country(name: "Spain", cities: ["Barcelona", "Madrid", "Bilbao"].map(City.init)),
            Country(name: "Sweden", cities: ["Stockholm"].map(City.init)),
            Country(name: "Switzerland", cities: ["Lausanne"].map(City.init)),
            Country(name: "Taiwan", cities: ["Taipei"].map(City.init)),
            Country(name: "Turkey", cities: ["Istanbul"].map(City.init)),
            Country(name: "UK", cities: ["London", "Glasgow"].map(City.init)),
            Country(name: "USA", cities: ["New_York_City", "Miami", "Chicago","Atlanta"].map(City.init))
        ]
    }()
}
