//
//  PlacesCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 24.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import FirebaseAnalytics
import SVProgressHUD
import UIKit

class PlacesCoordinator: CoordinatorType {
    private var router: UINavigationController
    private var context: AppContext
    private var placeType: PlaceType

    init(with router: UINavigationController, context: AppContext, type: PlaceType) {
        self.router = router
        self.context = context
        self.placeType = type
    }

    func start() {
        guard let country = context.countriesRepository.currentCountry,
            let city = context.countriesRepository.currentCity else { return }

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
        metrosVC.onOpenPlaces = { [weak self] metro, places in
            let allPlacesVC = Storyboard.Places.allPlacesListVC
            allPlacesVC.onOpenDetails = vc.onOpenDetails
            allPlacesVC.title = metro.name
            allPlacesVC.additionalSafeAreaInsets = .zero
            self?.router.pushViewController(allPlacesVC, animated: true)
        }
        vc.metroViewController = metrosVC

        router.pushViewController(vc, animated: true)
    }

    private func openPlaceDetails(with place: Place) {
        let vc = Storyboard.Places.placeDetailsVC
        vc.place = place
		vc.city = context.countriesRepository.currentCity
        vc.onCall = { [weak self] place in
            guard let phoneNumber = place.phoneNumber,
                !phoneNumber.isEmpty,
                let numberURL = URL(string: "telprompt://" + phoneNumber) else { return }

            UIApplication.shared.open(numberURL, options: [:], completionHandler: nil)

            self?.context.analytics.trackEvent(with: .callClicked(place.name, place.phoneNumber ?? "not a number"))
        }
        vc.onWebsite = { [weak self] place in
            guard let website = place.website,
                !website.isEmpty,
                let url = URL(string: website) else { return }

            let webBrowser = WebBrowserViewController()
            webBrowser.url = url
            self?.router.pushViewController(webBrowser, animated: true)

            self?.context.analytics.trackEvent(with: .websiteClicked(place.name, place.website ?? "no url"))
        }
		vc.showSubscription = { [weak self] in
			self?.showSubscription()
		}
        router.pushViewController(vc, animated: true)

        context.analytics.trackEvent(with: .detailsPageView(place.name))
        context.ads.handleEvent(with: .openDetailsPage)
    }

	private func showSubscription() {
		let vc = Storyboard.Subscription.sunscriptionVC
		vc.present(from: router)
	}
}
