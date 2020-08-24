//
//  PlacesCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 24.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import SVProgressHUD
import UIKit

class PlacesCoordinator {
    private var router: UINavigationController
    private var context: AppContext
    private var placeType: PlaceType

    init(with router: UINavigationController, context: AppContext, type: PlaceType) {
        self.router = router
        self.context = context
        self.placeType = type
    }

    func start() {
        guard let country = context.userStorageService.currentCountry,
            let city = context.userStorageService.currentCity else { return }

        SVProgressHUD.show()

        context.placesRepository.getPlacesByMetros(with: placeType, country: country, city: city) { [weak self] result in
            switch result {
            case .success(let metrosAndPlaces):
                SVProgressHUD.dismiss()
                self?.openPlacesVC(with: metrosAndPlaces)
            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                SVProgressHUD.dismiss(withDelay: 3.0)
                break
            }
        }
    }

    private func openPlacesVC(with metrosAndPlaces: [MetroStation: [Place]]) {
        let vc = Storyboard.Places.placesVC

        vc.metrosAndPlaces = metrosAndPlaces

        vc.onOpenDetails = { [weak self] place in
            self?.openPlaceDetails(with: place)
        }

        let allPlacesVC = Storyboard.Places.allPlacesListVC
        allPlacesVC.onOpenDetails = vc.onOpenDetails
        vc.allPlacesViewController = allPlacesVC

        let metrosVC = Storyboard.Places.metroListVC
        metrosVC.onOpenPlaces = { [weak self] places in
            let allPlacesVC = Storyboard.Places.allPlacesListVC
            allPlacesVC.onOpenDetails = vc.onOpenDetails
            self?.router.pushViewController(allPlacesVC, animated: true)
        }
        vc.metroViewController = metrosVC

        router.pushViewController(vc, animated: true)
    }

    private func openPlaceDetails(with place: Place) {
        let vc = Storyboard.Places.placeDetailsVC
        vc.place = place
        router.pushViewController(vc, animated: true)
    }
}
