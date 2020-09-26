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
            "Argentina", "Austria", "Belgium", "Brazil", "Bulgaria", "Denmark", "Canada", "Emirates",
            "Finland", "France", "Georgia", "Germany", "India", "Italy", "Japan", "Malaysia", "Mexico",
            "Norway", "Portugal", "Russia","S_Korea", "Singapore", "Spain", "Sweden",
            "Switzerland", "Taiwan", "Turkey", "UK", "USA"
        ].compactMap { country(with: $0) }
    }()

    func country(with name: String?) -> Country? {
        switch name {
        case "Argentina": return Country(name: "Argentina", cities: ["Buenos_Aires"].compactMap { city(with: $0) })
        case "Austria": return Country(name: "Austria", cities: ["Vienna"].compactMap { city(with: $0) })
        case "Belgium": return Country(name: "Belgium", cities: ["Brussels"].compactMap { city(with: $0) })
        case "Brazil": return Country(name: "Brazil", cities: ["Rio_de_Janeiro", "Sao_Paulo"].compactMap { city(with: $0) })
        case "Bulgaria": return Country(name: "Bulgaria", cities: ["Sofia"].compactMap { city(with: $0) })
        case "Canada": return Country(name: "Canada", cities: ["Montreal", "Toronto", "Vancouver"].compactMap { city(with: $0) })
        case "Denmark": return Country(name: "Denmark", cities: ["Copenhagen"].compactMap { city(with: $0) })
        case "Emirates": return Country(name: "Emirates", cities: ["Dubai"].compactMap { city(with: $0) })
        case "Finland": return Country(name: "Finland", cities: ["Helsinki"].compactMap { city(with: $0) })
        case "France": return Country(name: "France", cities: ["Paris", "Marseille", "Lyon", "Toulouse"].compactMap { city(with: $0) })
        case "Georgia": return Country(name: "Georgia", cities: ["Tbilisi"].compactMap { city(with: $0) })
        case "Germany": return Country(name: "Germany", cities: ["Berlin", "Hamburg", "Munich"].compactMap { city(with: $0) })
        case "India": return Country(name: "India", cities: ["Delhi", "Kolkata", "Mumbai"].compactMap { city(with: $0) })
        case "Italy": return Country(name: "Italy", cities: ["Rome", "Milan"].compactMap { city(with: $0) })
        case "Japan": return Country(name: "Japan", cities: ["Tokyo", "Osaka", "Yokohama", "Nagoya"].compactMap { city(with: $0) })
        case "Malaysia": return Country(name: "Malaysia", cities: ["Kuala_Lumpur"].compactMap { city(with: $0) })
        case "Mexico": return Country(name: "Mexico", cities: ["Mexico_City"].compactMap { city(with: $0) })
        case "Norway": return Country(name: "Norway", cities: ["Oslo"].compactMap { city(with: $0) })
        case "Portugal": return Country(name: "Portugal", cities: ["Lisbon"].compactMap { city(with: $0) })
        case "Russia": return Country(name: "Russia", cities: ["Moscow", "Saint_Petersburg", "Yekaterinburg"].compactMap { city(with: $0) })
        case "S_Korea": return Country(name: "S_Korea", cities: ["Seoul", "Busan"].compactMap { city(with: $0) })
        case "Singapore": return Country(name: "Singapore", cities: ["Singapore"].compactMap { city(with: $0) })
        case "Spain": return Country(name: "Spain", cities: ["Barcelona", "Madrid", "Bilbao"].compactMap { city(with: $0) })
        case "Sweden": return Country(name: "Sweden", cities: ["Stockholm"].compactMap { city(with: $0) })
        case "Switzerland": return Country(name: "Switzerland", cities: ["Lausanne"].compactMap { city(with: $0) })
        case "Taiwan": return Country(name: "Taiwan", cities: ["Taipei"].compactMap { city(with: $0) })
        case "Turkey": return Country(name: "Turkey", cities: ["Istanbul"].compactMap { city(with: $0) })
        case "UK": return Country(name: "UK", cities: ["London", "Glasgow"].compactMap { city(with: $0) })
        case "USA": return Country(name: "USA", cities: ["Atlanta", "Boston", "Chicago", "Miami", "New_York_City", "Philadelphia"].compactMap { city(with: $0) })
        default: return nil
        }
    }

    func city(with name: String?) -> City? {
        switch name {
            
        case "Buenos_Aires": return City(name: "Buenos Aires", plistName: "Buenos_Aires", metroPlanImage: #imageLiteral(resourceName: "Buenos_Aires_Map"))
        case "Vienna": return City(name: "Vienna", metroPlanImage: #imageLiteral(resourceName: "Vienna_Map"))
        case "Brussels": return City(name: "Brussels", metroPlanImage: #imageLiteral(resourceName: "Brussels_Map"))
        case "Rio_de_Janeiro": return City(name: "Rio de Janeiro", plistName: "Rio_de_Janeiro", metroPlanImage: #imageLiteral(resourceName: "Rio_de_Janeiro_Map"))
        case "Sao_Paulo": return City(name: "Sao Paulo", plistName: "Sao_Paulo", metroPlanImage: #imageLiteral(resourceName: "Sao_Paulo_Map"))
        case "Sofia": return City(name: "Sofia", metroPlanImage: #imageLiteral(resourceName: "Sofia_Map"))
        case "Montreal": return City(name: "Montreal", metroPlanImage: #imageLiteral(resourceName: "Montreal_Map"))
        case "Toronto": return City(name: "Toronto", metroPlanImage: #imageLiteral(resourceName: "Toronto_Map"))
        case "Vancouver": return City(name: "Vancouver", metroPlanImage: #imageLiteral(resourceName: "Vancouver_Map"))
        case "Copenhagen": return City(name: "Copenhagen", metroPlanImage: #imageLiteral(resourceName: "Copenhagen_Map"))
        case "Dubai": return City(name: "Dubai", metroPlanImage: #imageLiteral(resourceName: "Dubai_Map"))
        case "Helsinki": return City(name: "Helsinki", metroPlanImage: #imageLiteral(resourceName: "Helsinki_Map"))
        case "Paris": return City(name: "Paris", metroPlanImage: #imageLiteral(resourceName: "Paris_Map"))
        case "Marseille": return City(name: "Marseille", metroPlanImage: #imageLiteral(resourceName: "Marseille_Map"))
        case "Lyon": return City(name: "Lyon", metroPlanImage: #imageLiteral(resourceName: "Lyon_Map"))
        case "Toulouse": return City(name: "Toulouse", metroPlanImage: #imageLiteral(resourceName: "Toulouse_Map"))
        case "Tbilisi": return City(name: "Tbilisi", metroPlanImage: #imageLiteral(resourceName: "Tbilisi_Map"))
        case "Berlin": return City(name: "Berlin", metroPlanImage: #imageLiteral(resourceName: "Berlin_Map"))
        case "Hamburg": return City(name: "Hamburg", metroPlanImage: #imageLiteral(resourceName: "Hamburg_Map"))
        case "Munich": return City(name: "Munich", metroPlanImage: #imageLiteral(resourceName: "Munich_Map"))

        case "Delhi": return City(name: "Delhi", metroPlanImage: #imageLiteral(resourceName: "Delhi_Map"))
        case "Kolkata": return City(name: "Kolkata", metroPlanImage: #imageLiteral(resourceName: "Kolkata_Map"))
        case "Mumbai": return City(name: "Mumbai", metroPlanImage: #imageLiteral(resourceName: "Mumbai_Map"))
        case "Rome": return City(name: "Rome", metroPlanImage: #imageLiteral(resourceName: "Rome_Map"))
        case "Milan": return City(name: "Milan", metroPlanImage: #imageLiteral(resourceName: "Milan_Map"))

        case "Tokyo": return City(name: "Tokyo", metroPlanImage: #imageLiteral(resourceName: "Tokyo_Map"))
        case "Osaka": return City(name: "Osaka", metroPlanImage: #imageLiteral(resourceName: "Osaka_Map"))
        case "Yokohama": return City(name: "Yokohama", metroPlanImage: #imageLiteral(resourceName: "Yokohama_Map"))
        case "Nagoya": return City(name: "Nagoya", metroPlanImage: #imageLiteral(resourceName: "Nagoya_Map"))

        case "Kuala_Lumpur": return City(name: "KualaLumpur", plistName: "Kuala_Lumpur", metroPlanImage: #imageLiteral(resourceName: "Kuala_Lumpur_Map"))
        case "Mexico_City": return City(name: "Mexico City", plistName: "Mexico_City", metroPlanImage: #imageLiteral(resourceName: "Mexico_City_Map"))
        case "Oslo": return City(name: "Oslo", metroPlanImage: #imageLiteral(resourceName: "Oslo_Map"))
        case "Lisbon": return City(name: "Lisbon", metroPlanImage: #imageLiteral(resourceName: "Lisbon_Map"))

        case "Moscow": return City(name: "Moscow", metroPlanImage: #imageLiteral(resourceName: "Moscow_Map"))
        case "Saint_Petersburg": return City(name: "Saint Petersburg", plistName: "Saint_Petersburg", metroPlanImage: #imageLiteral(resourceName: "Saint_Petersburg_Map"))
        case "Yekaterinburg": return City(name: "Yekaterinburg", metroPlanImage: #imageLiteral(resourceName: "Yekaterinburg_Map"))

        case "Seoul": return City(name: "Seoul", metroPlanImage: #imageLiteral(resourceName: "Seoul_Map"))
        case "Busan": return City(name: "Busan", metroPlanImage: #imageLiteral(resourceName: "Busan_Map"))

        case "Singapore": return City(name: "Singapore", metroPlanImage: #imageLiteral(resourceName: "Singapore_Map"))

        case "Barcelona": return City(name: "Barcelona", metroPlanImage: #imageLiteral(resourceName: "Barcelona_Map"))
        case "Madrid": return City(name: "Madrid", metroPlanImage: #imageLiteral(resourceName: "Madrid_Map"))
        case "Bilbao": return City(name: "Bilbao", metroPlanImage: #imageLiteral(resourceName: "Bilbao_Map"))

        case "Stockholm": return City(name: "Stockholm", metroPlanImage: #imageLiteral(resourceName: "Stockholm_Map"))
        case "Lausanne": return City(name: "Lausanne", metroPlanImage: #imageLiteral(resourceName: "Lausanne_Map"))
        case "Taipei": return City(name: "Taipei", metroPlanImage: #imageLiteral(resourceName: "Taipei_Map"))
        case "Istanbul": return City(name: "Istanbul", metroPlanImage: #imageLiteral(resourceName: "Istanbul_Map"))
        case "London": return City(name: "London", metroPlanImage: #imageLiteral(resourceName: "London_Map"))
        case "Glasgow": return City(name: "Glasgow", metroPlanImage: #imageLiteral(resourceName: "Glasgow_Map"))

        case "Atlanta": return City(name: "Atlanta", metroPlanImage: #imageLiteral(resourceName: "Atlanta_Map"))
        case "Boston": return City(name: "Boston", metroPlanImage: #imageLiteral(resourceName: "Boston_Map.png"))
        case "Chicago": return City(name: "Chicago", metroPlanImage: #imageLiteral(resourceName: "Chicago_Map"))
        case "Miami": return City(name: "Miami", metroPlanImage: #imageLiteral(resourceName: "Miami_Map"))
        case "New_York_City": return City(name: "New York City", plistName: "New_York_City", metroPlanImage: #imageLiteral(resourceName: "New_York_City_Map"))
        case "Philadelphia": return City(name: "Philadelphia", metroPlanImage: #imageLiteral(resourceName: "Philadelphia_Map.png"))
           
        default: return nil
        }
    }
}
