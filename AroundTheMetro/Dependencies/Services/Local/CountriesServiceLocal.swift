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
            Country(name: "Austria", cities: ["Vienna"].map(City)),
            Country(name: "Canada", cities: ["Montreal", "Toronto", "Vancouver"].map(City)),
            Country(name: "Emirates", cities: ["Dubai"].map(City)),
            Country(name: "France", cities: ["Paris", "Marseille", "Lyon", "Toulouse"].map(City)),
            Country(name: "India", cities: ["Delhi", "Kolkata", "Mumbai"].map(City)),
            Country(name: "Italy", cities: ["Rome", "Milan"].map(City)),
            Country(name: "Japan", cities: ["Tokyo", "Osaka", "Yokohama", "Nagoya"].map(City)),
            Country(name: "S_Korea", cities: ["Seoul", "Busan"].map(City)),
            Country(name: "Spain", cities: ["Barcelona", "Madrid", "Bilbao"].map(City)),
            Country(name: "Sweden", cities: ["Stockholm"].map(City)),
            Country(name: "Switzerland", cities: ["Lausanne"].map(City)),
            Country(name: "Taiwan", cities: ["Taipei"].map(City)),
            Country(name: "Turkey", cities: ["Istanbul"].map(City)),
            Country(name: "UK", cities: ["London", "Glasgow"].map(City)),
            Country(name: "USA", cities: ["New_York_City", "Miami", "Chicago","Atlanta"].map(City))
        ]
    }()
}
