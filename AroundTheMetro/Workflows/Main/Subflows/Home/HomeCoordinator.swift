//
//  HomeCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import SVProgressHUD
import UIKit

class HomeCoordinator: BaseCoordinator {
    var onShare: (() -> Void)?
    var onMenu: (() -> Void)?

    private var context: AppContext

    private var homeViewController: HomeViewController?

    init(with router: RouterType, context: AppContext) {
        self.context = context
        super.init(with: router)
    }

    override func start() {
        let viewController = Storyboard.Home.homeVC
        initialContainer = viewController
        homeViewController = viewController
        homeViewController?.title = context.countriesRepository.currentCity?.name

        updateBanners()

        homeViewController?.menuItems =
        [
            MenuItem(type: .metroPlan, onSelect: { [weak self] in
                self?.openMetroPlan()
            }),
            MenuItem(type: .locateMetro, onSelect: { [weak self] in
                self?.openLocateMetro()
            }),
            MenuItem(type: .attractions, onSelect: { [weak self] in
                self?.openPlaces(with: .attraction)
            }),
            MenuItem(type: .restoraunts, onSelect: { [weak self] in
                self?.openPlaces(with: .restoraunt)
            }),
            MenuItem(type: .boutiques, onSelect: { [weak self] in
                self?.openPlaces(with: .boutique)
            }),
            MenuItem(type: .beautyAndHealth, onSelect: { [weak self] in
                self?.openPlaces(with: .beautyAndHealth)
            })
        ]
        homeViewController?.onLeftBarButton = onMenu
        homeViewController?.onRightBarButton = onShare
        router.show(container: viewController, animated: true)
    }

    private func openMetroPlan() {
        let vc = Storyboard.Home.metroPlanVC
        vc.city = context.countriesRepository.currentCity
        vc.title = context.countriesRepository.currentCity?.name
        router.show(container: vc, animated: true)
    }
    
    private func openLocateMetro() {
        guard let country = context.countriesRepository.currentCountry,
            let city = context.countriesRepository.currentCity else { return }

        SVProgressHUD.show()

        context.metroLocationsRepository.getMetroLocations(
            country: country,
            city: city) { [weak self] result in
                switch result {
                case .success(let stations):
                    SVProgressHUD.dismiss()
                    let vc = Storyboard.Home.locateMetroVC
                    vc.stations = stations
                    vc.title = city.name
                    self?.router.show(container: vc, animated: true)
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    SVProgressHUD.dismiss(withDelay: 3.0)
                }
        }
    }

    private func openPlaces(with placeType: PlaceType) {
        let placesCoordinator = PlacesCoordinator(with: router, context: context, type: placeType)
        addDependency(placesCoordinator)
        placesCoordinator.onComplete = { [weak self] _ in
            self?.removeDependency(placesCoordinator)
        }
        placesCoordinator.start()
    }

    func updateBanners() {
        guard let country = context.countriesRepository.currentCountry,
            let city = context.countriesRepository.currentCity else { return }

        context.bannersRepository.getBanners(country: country, city: city, with: { [weak self] result in
            switch result {
            case .success(let banners):
                self?.homeViewController?.banners = banners
            case .failure(_):
                // TODO: Handle error
                break
            }
        })
    }
}
