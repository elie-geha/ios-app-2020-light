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

    // repositories
    private var countriesRepository: CountriesRepository?
    private var placesRepoository: PlacesRepository?

    // services
    // settings service?

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
                                          placesRepoository: placesRepoository)
        mainCoordinator?.start()
    }

    private func createDependencies() {
        countriesRepository = CountriesRepository(countriesService: CountriesServiceLocal())
        placesRepoository = PlacesRepository(placesService: PlacesServiceRemote())
    }
}
