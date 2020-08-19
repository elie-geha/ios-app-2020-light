//
//  CountriesRepository.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

class CountriesRepository: Repository {
    var countriesService: CountriesServiceLocal

    init(countriesService: CountriesServiceLocal) {
        self.countriesService = countriesService
    }

    func getCountries(result: ((Result<[Country], Error>) -> Void)?) {
        result?(.success(countriesService.allCountries))
    }
}
