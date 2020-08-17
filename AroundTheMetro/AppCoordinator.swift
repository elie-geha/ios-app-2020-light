//
//  AppCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

class AppCoordinator {
    let window: UIWindow
    private var mainCoordinator: MainCoordinator?

    // MARK: - repositories
    private var countriesRepository: CountriesRepository!
    private var placesRepository: PlacesRepository!

    // MARK: - services
    private var userStorageService: UserStorageService!

    // MARK: -

    init(with window: UIWindow) {
        self.window = window

        createDependencies()
    }

    func start() {
        let router = UINavigationController()
        router.setNavigationBarHidden(true, animated: false)
        window.rootViewController = router
        mainCoordinator = MainCoordinator(with: router,
                                          countriesRepository: countriesRepository,
                                          placesRepository: placesRepository,
                                          userStorageService: userStorageService)
        mainCoordinator?.start()
    }

    private func createDependencies() {
        countriesRepository = CountriesRepository(countriesService: CountriesServiceLocal())
        placesRepository = PlacesRepository(placesService: PlacesServiceRemote())

        userStorageService = UserStorageService()
    }
}
