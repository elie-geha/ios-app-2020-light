//
//  HomeCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import SVProgressHUD
import UIKit

class HomeCoordinator {
    var onShare: (() -> Void)?
    var onMenu: (() -> Void)?

    private var router: UINavigationController
    private var context: AppContext

    private var placesCoordinator: PlacesCoordinator?

    init(with router: UINavigationController, context: AppContext) {
        self.router = router
        self.context = context
    }

    func start() {
        let viewController = Storyboard.Home.homeVC
        viewController.bannersRepository = context.bannersRepository
        viewController.userStorage = context.userStorageService
        viewController.menuItems =
        [
            MenuItem(type: .metroPlan, onSelect: { [weak self] in
                self?.openMetroPlan()
            }),
            MenuItem(type: .locateMetro, onSelect: { [weak self] in
                self?.openLocateMetro()
            }),
            MenuItem(type: .restoraunts, onSelect: { [weak self] in
                self?.openPlaces(with: .restoraunt)
            }),
            MenuItem(type: .boutiques, onSelect: { [weak self] in
                self?.openPlaces(with: .boutique)
            }),
            MenuItem(type: .beautyAndHealth, onSelect: { [weak self] in
                self?.openPlaces(with: .beautyAndHealth)
            }),
            MenuItem(type: .attractions, onSelect: { [weak self] in
                self?.openPlaces(with: .attraction)
            })
        ]
        viewController.onLeftBarButton = onMenu
        viewController.onRightBarButton = onShare
        router.setViewControllers([viewController], animated: false)
    }

    private func openMetroPlan() {
        /// TODO
    }
    
    private func openLocateMetro() {
        guard let country = context.userStorageService.currentCountry,
            let city = context.userStorageService.currentCity else { return }

        SVProgressHUD.show()

        context.metroLocationsRepository.getMetroLocations(
            country: country,
            city: city) { [weak self] result in
                switch result {
                case .success(let stations):
                    SVProgressHUD.dismiss()
                    let vc = Storyboard.Home.locateMetroVC
                    vc.stations = stations
                    self?.router.pushViewController(vc, animated: true)
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    SVProgressHUD.dismiss(withDelay: 3.0)
                }
        }
    }

    private func openPlaces(with placeType: PlaceType) {
        placesCoordinator = PlacesCoordinator(with: router, context: context, type: placeType)
        placesCoordinator?.start()
    }
}
