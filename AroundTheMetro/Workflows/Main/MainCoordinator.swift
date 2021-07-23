//
//  MainCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import AKSideMenu
import UIKit

class MainCoordinator: CoordinatorType {
    // MARK: - Context
    private var context: AppContext

    // MARK: - Navigation
    private var router: UINavigationController

    private var sideMenuController: AKSideMenu?

    private var homeCoordinator: HomeCoordinator!
    private var menuCoordinator: MenuCoordinator!

    private var homeCoordinatorRouter: UINavigationController!

    private var menuCoordinatorRouter: UINavigationController!
    private var changeCityRouter: UINavigationController!
    private var changeCityController: ChangeCityViewController!
    private var contactUsController: ContactUsController!
    private var subscriptionViewController: SubScriptionViewController!

    private var shareRouter: UINavigationController!
    
    // MARK: -
    init(with router: UINavigationController,
         context: AppContext) {
        self.router = router
        self.context = context

        createHomeCoordinator()
        createMenuCoordinator()
        createChangeCity()
        createContactUs()
		createSubscription()
        createShare()
    }

    func start() {
        let sideMenuController = AKSideMenu(contentViewController: initialMainRouter(),
                                            leftMenuViewController: menuCoordinatorRouter,
                                            rightMenuViewController: shareRouter)
        self.sideMenuController = sideMenuController
        setupSideMenu()

        router.setViewControllers([sideMenuController], animated: false)
    }

    private func setupSideMenu() {
        sideMenuController?.menuPreferredStatusBarStyle = UIStatusBarStyle.lightContent
        sideMenuController?.contentViewShadowColor = UIColor.black
        sideMenuController?.contentViewShadowOffset = CGSize(width: 0, height: 0)
        sideMenuController?.contentViewShadowOpacity = 0.6
        sideMenuController?.contentViewShadowRadius = 12
        sideMenuController?.contentViewShadowEnabled = true
        sideMenuController?.backgroundImage = Assets.menuBackground
    }

    private func initialMainRouter() -> UINavigationController {
        if context.countriesRepository.currentCity == nil && context.countriesRepository.currentCountry == nil {
            showChangeCity(fromLeftMenu: false)
            return changeCityRouter
        } else {
            return homeCoordinatorRouter
        }
    }

    private func createHomeCoordinator() {
        homeCoordinatorRouter = UINavigationController()
        homeCoordinator = HomeCoordinator(with: homeCoordinatorRouter, context: context)
        homeCoordinator.onMenu = { [weak self] in
            self?.sideMenuController?.presentLeftMenuViewController()
        }
        homeCoordinator.onShare = { [weak self] in
//            self?.sideMenuController?.presentRightMenuViewController()

			let items: [Any] = ["Discover interesting places around metro stations. Available in more the 70+ cities. Download the Free App Here", URL(string: "https://apps.apple.com/us/app/id1276636784")!]
			let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            if (ac.popoverPresentationController != nil) {
                ac.popoverPresentationController?.sourceView = self?.router.view
            }
			self?.router.present(ac, animated: true)
        }
        homeCoordinator.start()
    }

    private func createMenuCoordinator() {
        menuCoordinatorRouter = UINavigationController()
        menuCoordinatorRouter.setNavigationBarHidden(true, animated: false)
        menuCoordinator = MenuCoordinator(with: menuCoordinatorRouter)
        menuCoordinator.onHome = { [weak self] in
            self?.setContentViewController(self?.homeCoordinatorRouter)
        }
        menuCoordinator.onChangeCity = { [weak self] in
            self?.showChangeCity()
        }
        menuCoordinator.onContactUs = { [weak self] in
            self?.showContactUs()
        }
		menuCoordinator.onSubscription = { [weak self] in
			self?.showSubscription()
		}
		menuCoordinator.onProfile = { [weak self] in
			self?.showProfile()
		}
		menuCoordinator.onLogin = { [weak self] in
			self?.showLogin()
		}
        menuCoordinator.start()
    }

    private func createChangeCity() {
        let changeCityVC = Storyboard.Menu.changeCityVC
        self.changeCityController = changeCityVC
        changeCityVC.onConfirm = { [weak self] selectedCountry, selectedCity in
            self?.context.countriesRepository.currentCountry = selectedCountry
            self?.context.countriesRepository.currentCity = selectedCity
            self?.homeCoordinator.start()
            self?.setContentViewController(self?.homeCoordinatorRouter)
        }
        changeCityRouter = UINavigationController(rootViewController: changeCityVC)
    }

    private func createContactUs() {
        contactUsController = ContactUsController()
    }

    private func createSubscription() {
		subscriptionViewController = Storyboard.Subscription.sunscriptionVC
    }

    private func createShare() {
        let shareVC = UIViewController() // instantiate from storyboard
        shareRouter = UINavigationController(rootViewController: shareVC)
    }

    private func setContentViewController(_ viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        sideMenuController?.hideMenuViewController()
        sideMenuController?.setContentViewController(viewController, animated: true)
    }

    private func showContactUs() {
        contactUsController.present(from: router)
    }

	private func showSubscription() {
		subscriptionViewController.present(from: router)
	}

	private func showProfile() {
		let profileViewController = Storyboard.Auth.profileVC
        profileViewController.city = context.countriesRepository.currentCity?.name
		let nav = UINavigationController(rootViewController: profileViewController)
        
		router.present(nav, animated: true, completion: nil)
//		profileViewController.present(from: router)
	}

	private func showLogin() {
		let loginViewController = Storyboard.Auth.loginVC
        let nav = UINavigationController(rootViewController: loginViewController)
        nav.navigationBar.isHidden = true
        router.present(nav, animated: true, completion: nil)
//		loginViewController.present(from: router)
	}

    private func showChangeCity(fromLeftMenu: Bool = true) {
        changeCityController.isFromLeftMenu = fromLeftMenu
        setContentViewController(changeCityRouter)

        context.countriesRepository.getCountries { [weak self] result in
            switch result {
            case .success(let countries):
                self?.changeCityController.set(countries: countries,
                                               selectedCountry: self?.context.countriesRepository.currentCountry,
                                               selectedCity: self?.context.countriesRepository.currentCity)
            case .failure(_):
                // TODO: handle errors
                break
            }
        }
    }
}
