//
//  CountriesRepository.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

class CountriesRepository: Repository {
    var countriesService: CountriesServiceLocal
    var userStorageService: UserStorageService

    init(countriesService: CountriesServiceLocal, userStorageService: UserStorageService) {
        self.countriesService = countriesService
        self.userStorageService = userStorageService
    }

    var currentCountry: Country? {
        get {
            return countriesService.country(with: userStorageService.currentCountry)
        }
        set {
            userStorageService.currentCountry = newValue?.name
        }
    }

    var currentCity: City? {
        get {
            return countriesService.city(with: userStorageService.currentCity)
        }
        set {
            userStorageService.currentCity = newValue?.name
        }
    }

    func getCountries(result: ((Result<[Country], Error>) -> Void)?) {
        result?(.success(countriesService.allCountries))
    }
}
