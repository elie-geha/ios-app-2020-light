//
//  AppContext.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 18.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

class AppContext {
    // MARK: - repositories
    let countriesRepository: CountriesRepository
    let placesRepository: PlacesRepository
    let metroLocationsRepository: MetroLocationsRepository
    let bannersRepository: BannersRepositoryType

    // MARK: - services
    let userStorageService: UserStorageService

    init() {
        userStorageService = UserStorageService()

        countriesRepository = CountriesRepository(countriesService: CountriesServiceLocal(),
                                                  userStorageService: userStorageService)
        placesRepository = PlacesRepository(placesService: PlacesServiceRemote())
        metroLocationsRepository = MetroLocationsRepository(metroLocationsService: MetroLocationsService())
        bannersRepository = BannersRepository(bannersService: BannersServiceRemote())
    }
}
