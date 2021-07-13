//
//  HomeCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import SVProgressHUD
import UIKit
import FirebaseAuth

class HomeCoordinator: CoordinatorType {
    var onShare: (() -> Void)?
    var onMenu: (() -> Void)?

    private var router: UINavigationController
    private var context: AppContext

    private var placesCoordinator: PlacesCoordinator?

    private var homeViewController: HomeViewController?

    init(with router: UINavigationController, context: AppContext) {
        self.router = router
        self.context = context
    }

    func start() {

		navigateToHome()
//		if Auth.auth().currentUser == nil {
//			DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
//				self?.navigateToLogin()
//			}
//		}

    }

	var isLoggedIn: Bool {Auth.auth().currentUser != nil}
	private func navigateToHome() {

		homeViewController = Storyboard.Home.homeVC
		homeViewController?.title = context.countriesRepository.currentCity?.name

		updateBanners()

		homeViewController?.menuItems =
		[
			MenuItem(type: .metroPlan, onSelect: { [weak self] in
				guard self?.isLoggedIn ?? false else {
					self?.navigateToLogin()
					return
				}
				self?.openMetroPlan()
			}),
			MenuItem(type: .locateMetro, onSelect: { [weak self] in
				guard self?.isLoggedIn ?? false else {
					self?.navigateToLogin()
					return
				}
				self?.openLocateMetro()
			}),
			MenuItem(type: .attractions, onSelect: { [weak self] in
				guard self?.isLoggedIn ?? false else {
					self?.navigateToLogin()
					return
				}
				self?.openPlaces(with: .attraction)
			}),
			MenuItem(type: .restoraunts, onSelect: { [weak self] in
				guard self?.isLoggedIn ?? false else {
					self?.navigateToLogin()
					return
				}
				self?.openPlaces(with: .restoraunt)
			}),
			MenuItem(type: .boutiques, onSelect: { [weak self] in
				guard self?.isLoggedIn ?? false else {
					self?.navigateToLogin()
					return
				}
				self?.openPlaces(with: .boutique)
			}),
			MenuItem(type: .beautyAndHealth, onSelect: { [weak self] in
				guard self?.isLoggedIn ?? false else {
					self?.navigateToLogin()
					return
				}
				self?.openPlaces(with: .beautyAndHealth)
			})
		]
		homeViewController?.logout =  { [weak self] in
			self?.navigateToLogin()
		}
		homeViewController?.onLeftBarButton = onMenu
		homeViewController?.onRightBarButton = onShare
		router.setViewControllers([homeViewController].compactMap { $0 }, animated: false)
	}
	private func navigateToLogin() {
		guard let login = UIStoryboard(name: "Auth", bundle: .main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {return}
		let nav = UINavigationController(rootViewController: login)
		nav.setNavigationBarHidden(true, animated: false)
//		nav.modalPresentationStyle = .fullScreen
		login.showHome = { [weak self] in
			self?.router.dismiss(animated: true, completion: nil)
		}
		router.present(nav, animated: true, completion: nil)
	}

    private func openMetroPlan() {
        let vc = Storyboard.Home.metroPlanVC
        vc.city = context.countriesRepository.currentCity
        vc.title = context.countriesRepository.currentCity?.name
        router.pushViewController(vc, animated: true)
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
