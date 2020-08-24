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
            "Austria", "Canada", "Emirates", "France", "India",
            "Italy", "Japan", "S_Korea", "Spain", "Sweden",
            "Switzerland", "Taiwan", "Turkey", "UK", "USA"
        ].compactMap { country(with: $0) }
    }()

    func country(with name: String?) -> Country? {
        switch name {
        case "Austria": return Country(name: "Austria", cities: ["Vienna"].compactMap { city(with: $0) })
        case "Canada": return Country(name: "Canada", cities: ["Montreal", "Toronto", "Vancouver"].compactMap { city(with: $0) })
        case "Emirates": return Country(name: "Emirates", cities: ["Dubai"].compactMap { city(with: $0) })
        case "France": return Country(name: "France", cities: ["Paris", "Marseille", "Lyon", "Toulouse"].compactMap { city(with: $0) })
        case "India": return Country(name: "India", cities: ["Delhi", "Kolkata", "Mumbai"].compactMap { city(with: $0) })
        case "Italy": return Country(name: "Italy", cities: ["Rome", "Milan"].compactMap { city(with: $0) })
        case "Japan": return Country(name: "Japan", cities: ["Tokyo", "Osaka", "Yokohama", "Nagoya"].compactMap { city(with: $0) })
        case "S_Korea": return Country(name: "S_Korea", cities: ["Seoul", "Busan"].compactMap { city(with: $0) })
        case "Spain": return Country(name: "Spain", cities: ["Barcelona", "Madrid", "Bilbao"].compactMap { city(with: $0) })
        case "Sweden": return Country(name: "Sweden", cities: ["Stockholm"].compactMap { city(with: $0) })
        case "Switzerland": return Country(name: "Switzerland", cities: ["Lausanne"].compactMap { city(with: $0) })
        case "Taiwan": return Country(name: "Taiwan", cities: ["Taipei"].compactMap { city(with: $0) })
        case "Turkey": return Country(name: "Turkey", cities: ["Istanbul"].compactMap { city(with: $0) })
        case "UK": return Country(name: "UK", cities: ["London", "Glasgow"].compactMap { city(with: $0) })
        case "USA": return Country(name: "USA", cities: ["New_York_City", "Miami", "Chicago","Atlanta"].compactMap { city(with: $0) })
        default: return nil
        }
    }

    func city(with name: String?) -> City? {
        switch name {
        case "Vienna": return City(name: "Vienna", metroPlanImage: #imageLiteral(resourceName: "Vienna_Map"))
        case "Montreal": return City(name: "Montreal", metroPlanImage: #imageLiteral(resourceName: "Montreal_Map"))
        case "Paris": return City(name: "Paris", metroPlanImage: #imageLiteral(resourceName: "Paris_Map"))
        case "New_York_City":
            return City(name: "New York City", metroLocationsPlistFilename: "New_York_City", metroPlanImage: #imageLiteral(resourceName: "New_York_City_Map"))
        case "London": return City(name: "London", metroPlanImage: #imageLiteral(resourceName: "London_Map"))
        case "Barcelona": return City(name: "Barcelona", metroPlanImage: #imageLiteral(resourceName: "Barcelona_Map"))
        case "Toronto": return City(name: "Toronto", metroPlanImage: #imageLiteral(resourceName: "Toronto_Map"))
        case "Vancouver": return City(name: "Vancouver", metroPlanImage: #imageLiteral(resourceName: "Vancouver_Map"))
        case "Dubai": return City(name: "Dubai", metroPlanImage: #imageLiteral(resourceName: "Dubai_Map"))
        case "Marseille": return City(name: "Marseille", metroPlanImage: #imageLiteral(resourceName: "Marseille_Map"))
        case "Lyon": return City(name: "Lyon", metroPlanImage: #imageLiteral(resourceName: "Lyon_Map"))
        case "Toulouse": return City(name: "Toulouse", metroPlanImage: #imageLiteral(resourceName: "Toulouse_Map"))
        case "Delhi": return City(name: "Delhi", metroPlanImage: #imageLiteral(resourceName: "Delhi_Map"))
        case "Kolkata": return City(name: "Kolkata", metroPlanImage: #imageLiteral(resourceName: "Kolkata_Map"))
        case "Mumbai": return City(name: "Mumbai", metroPlanImage: #imageLiteral(resourceName: "Mumbai_Map"))
        case "Rome": return City(name: "Rome", metroPlanImage: #imageLiteral(resourceName: "Rome_Map"))
        case "Milan": return City(name: "Milan", metroPlanImage: #imageLiteral(resourceName: "Milan_Map"))
        case "Tokyo": return City(name: "Tokyo", metroPlanImage: #imageLiteral(resourceName: "Tokyo_Map"))
        case "Osaka": return City(name: "Osaka", metroPlanImage: #imageLiteral(resourceName: "Osaka_Map"))
        case "Yokohama": return City(name: "Yokohama", metroPlanImage: #imageLiteral(resourceName: "Yokohama_Map"))
        case "Nagoya": return City(name: "Nagoya", metroPlanImage: #imageLiteral(resourceName: "Nagoya_Map"))
        case "Seoul": return City(name: "Seoul", metroPlanImage: #imageLiteral(resourceName: "Seoul_Map"))
        case "Busan": return City(name: "Busan", metroPlanImage: #imageLiteral(resourceName: "Busan_Map"))
        case "Madrid": return City(name: "Madrid", metroPlanImage: #imageLiteral(resourceName: "Madrid_Map"))
        case "Bilbao": return City(name: "Bilbao", metroPlanImage: #imageLiteral(resourceName: "Bilbao_Map"))
        case "Stockholm": return City(name: "Stockholm", metroPlanImage: #imageLiteral(resourceName: "Stockholm_Map"))
        case "Lausanne": return City(name: "Lausanne", metroPlanImage: #imageLiteral(resourceName: "Lausanne_Map"))
        case "Taipei": return City(name: "Taipei", metroPlanImage: #imageLiteral(resourceName: "Taipei_Map"))
        case "Istanbul": return City(name: "Istanbul", metroPlanImage: #imageLiteral(resourceName: "Istanbul_Map"))
        case "Glasgow": return City(name: "Glasgow", metroPlanImage: #imageLiteral(resourceName: "Glasgow_Map"))
        case "Miami": return City(name: "Miami", metroPlanImage: #imageLiteral(resourceName: "Miami_Map"))
        case "Chicago": return City(name: "Chicago", metroPlanImage: #imageLiteral(resourceName: "Chicago_Map"))
        case "Atlanta": return City(name: "Atlanta", metroPlanImage: #imageLiteral(resourceName: "Atlanta_Map"))
        default: return nil
        }
    }
}
