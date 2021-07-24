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
        case "Belgium": return Country(name: "Beligum", cities: ["Brussels"].compactMap { city(with: $0) })
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
            
        case "Buenos_Aires": return City(name: "Buenos Aires", plistName: "Buenos_Aires", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Argentina_Buenos_Aires.png")
        case "Vienna": return City(name: "Vienna", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Austria_Vienna.png")
        case "Brussels": return City(name: "Brussels", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Belgium_Brussels.png")
        case "Rio_de_Janeiro": return City(name: "Rio de Janeiro", plistName: "Rio_de_Janeiro", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Brazil_Rio_de_Janeiro.png")
        case "Sao_Paulo": return City(name: "Sao Paulo", plistName: "Sao_Paulo", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Brazil_Sao_Paulo.png")
        case "Sofia": return City(name: "Sofia", metroPlanImageUrl: "") //do not delete
        case "Montreal": return City(name: "Montreal", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Canada_Montreal.png")
        case "Toronto": return City(name: "Toronto", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Canada_Toronto.png")
        case "Vancouver": return City(name: "Vancouver", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Canada_Vancouver.png")
        case "Copenhagen": return City(name: "Copenhagen", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Denmark_Copenhagen.png")
        case "Dubai": return City(name: "Dubai", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Emirates_Dubai.png")
        case "Helsinki": return City(name: "Helsinki", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Finland_Helsinki.png")
        case "Paris": return City(name: "Paris", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/France_Paris.png")
        case "Marseille": return City(name: "Marseille", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/France_Marseille.png")
        case "Lyon": return City(name: "Lyon", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/France_Lyon.png")
        case "Toulouse": return City(name: "Toulouse", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/France_Toulouse.png")
        case "Tbilisi": return City(name: "Tbilisi", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Georgia_Tbilisi.png")
        case "Berlin": return City(name: "Berlin", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Germany_Berlin.png")
        case "Hamburg": return City(name: "Hamburg", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Germany_Hamburg.png")
        case "Munich": return City(name: "Munich", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Germany_Munich.png")

        case "Delhi": return City(name: "Delhi", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/India_Delhi.png")
        case "Kolkata": return City(name: "Kolkata", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/India_Kolkata.png")
        case "Mumbai": return City(name: "Mumbai", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/India_Mumbai.png")
        case "Rome": return City(name: "Rome", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Italy_Rome.png")
        case "Milan": return City(name: "Milan", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Italy_Milan.png")

        case "Tokyo": return City(name: "Tokyo", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Japan_Tokyo.png")
        case "Osaka": return City(name: "Osaka", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Japan_Osaka.png")
        case "Yokohama": return City(name: "Yokohama", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Japan_Yokohama.png")
        case "Nagoya": return City(name: "Nagoya", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Japan_Nagoya.png")

        case "Kuala_Lumpur": return City(name: "KualaLumpur", plistName: "Kuala_Lumpur", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Malaysia_Kuala_Lumpur.png")
        case "Mexico_City": return City(name: "Mexico City", plistName: "Mexico_City", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Mexico_Mexico_City.png")
        case "Oslo": return City(name: "Oslo", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Norway_Oslo.png")
        case "Lisbon": return City(name: "Lisbon", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Portugal_Lisbon.png")

        case "Moscow": return City(name: "Moscow", metroPlanImageUrl: "") //do not delete
        case "Saint_Petersburg": return City(name: "Saint Petersburg", plistName: "Saint_Petersburg", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Russia_Saint_Petersburg.png")
        case "Yekaterinburg": return City(name: "Yekaterinburg", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Russia_Yekaterinburg.png")

        case "Seoul": return City(name: "Seoul", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/S_Korea_Seoul.png")
        case "Busan": return City(name: "Busan", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/S_Korea_Busan.png")

        case "Singapore": return City(name: "Singapore", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Singapore_Singapore.png")

        case "Barcelona": return City(name: "Barcelona", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Spain_Barcelona.png")
        case "Madrid": return City(name: "Madrid", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Spain_Madrid.png")
        case "Bilbao": return City(name: "Bilbao", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Spain_Bilbao.png")

        case "Stockholm": return City(name: "Stockholm", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Sweden_Stockholm.png")
        case "Lausanne": return City(name: "Lausanne", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Switzerland_Lausanne.png")
        case "Taipei": return City(name: "Taipei", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Taiwan_Taipei.png")
        case "Istanbul": return City(name: "Istanbul", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/Turkey_Istanbul.png")
        case "London": return City(name: "London", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/UK_London.png")
        case "Glasgow": return City(name: "Glasgow", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/UK_Glasgow.png")

        case "Atlanta": return City(name: "Atlanta", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/USA_Atlanta.png")
        case "Boston": return City(name: "Boston", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/USA_Boston.png")
        case "Chicago": return City(name: "Chicago", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/USA_Chicago.png")
        case "Miami": return City(name: "Miami", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/USA_Miami.png")
        case "New_York_City": return City(name: "New York City", plistName: "New_York_City", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/USA_New_York_City.png")
        case "Philadelphia": return City(name: "Philadelphia", metroPlanImageUrl: "http://aroundthemetro.com/assets/images/Metromap/USA_Philadelphia.png")
           
        default: return nil
        }
    }
}
