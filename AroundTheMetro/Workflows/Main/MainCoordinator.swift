//
//  MainCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import AKSideMenu
import SVProgressHUD
import UIKit

class MainCoordinator: BaseCoordinator {
    // MARK: - Context
    private var context: AppContext

    // MARK: - Navigation

    private var sideMenuController: AKSideMenu?

    private var homeCoordinator: HomeCoordinator!
    private var menuCoordinator: MenuCoordinator!

    private var homeCoordinatorRouter: RouterType!
    private var menuCoordinatorRouter: RouterType!
    private var changeCityRouter: RouterType!

    private var changeCityController: ChangeCityViewController!
    private var contactUsController: ContactUsController!

    // MARK: -

    init(with router: RouterType,
         context: AppContext) {
        self.context = context
        super.init(with: router)
        createHomeCoordinator()
        createMenuCoordinator()
        createChangeCity()
        createContactUs()
    }

    override func start() {
        let sideMenuController = AKSideMenu(contentViewController: initialMainRouter().asUIViewController() ?? UIViewController(),
                                            leftMenuViewController: menuCoordinatorRouter.asUIViewController(),
                                            rightMenuViewController: nil)
        self.sideMenuController = sideMenuController
        initialContainer = sideMenuController
        setupSideMenu()

        router.show(container: sideMenuController, animated: false)
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

    private func initialMainRouter() -> RouterType {
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
            self?.context.ads.handleEvent(with: .open(.leftMenu))
        }
        homeCoordinator.onShare = { [weak self] in
            self?.sideMenuController?.presentRightMenuViewController()
        }
        homeCoordinator.start()
    }

    private func createMenuCoordinator() {
        let menuCoordinatorRouter = UINavigationController()
        self.menuCoordinatorRouter = menuCoordinatorRouter
        menuCoordinatorRouter.setNavigationBarHidden(true, animated: false)
        menuCoordinator = MenuCoordinator(with: menuCoordinatorRouter, context: context)
        menuCoordinator.onLogin = { [weak self] in
            self?.showLogin()
            self?.context.ads.handleEvent(with: .open(.login))
        }
        menuCoordinator.onProfile = { [weak self] in
            self?.showProfile()
            self?.context.ads.handleEvent(with: .open(.profile))
        }
        menuCoordinator.onHome = { [weak self] in
            self?.setContentViewController(self?.homeCoordinatorRouter.asUIViewController())
        }
        menuCoordinator.onChangeCity = { [weak self] in
            self?.showChangeCity()
            self?.context.ads.handleEvent(with: .open(.changeCity))
        }
        menuCoordinator.onContactUs = { [weak self] in
            self?.showContactUs()
        }
        menuCoordinator.start()
    }

    private func createChangeCity() {
        let changeCityVC = StoryboardScene.Menu.changeCityViewController.instantiate()
        self.changeCityController = changeCityVC
        changeCityVC.onConfirm = { [weak self] selectedCountry, selectedCity in
            self?.context.countriesRepository.currentCountry = selectedCountry
            self?.context.countriesRepository.currentCity = selectedCity
            self?.homeCoordinator.start()
            self?.setContentViewController(self?.homeCoordinatorRouter.asUIViewController())
        }
        changeCityRouter = UINavigationController(rootViewController: changeCityVC)
    }

    private func createContactUs() {
        contactUsController = ContactUsController()
    }

    private func setContentViewController(_ viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        sideMenuController?.hideMenuViewController()
        sideMenuController?.setContentViewController(viewController, animated: true)
    }

    private func showContactUs() {
        guard let viewController = router.asUIViewController() else { return }
        contactUsController.present(from: viewController)
    }

    private func showChangeCity(fromLeftMenu: Bool = true) {
        changeCityController.isFromLeftMenu = fromLeftMenu
        setContentViewController(changeCityRouter.asUIViewController())

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

    private func showLogin() {
        let authRouter = UINavigationController()
        authRouter.setNavigationBarHidden(true, animated: false)
        let authCoordinator = AuthorizationCoordinator(with: authRouter, context: context)
        authCoordinator.onComplete = { [weak self] success in
            if success {
                self?.menuCoordinator.restart()
                self?.router.hide(container: authRouter, animated: true)
                self?.removeDependency(authCoordinator)
            }
        }
        authCoordinator.start()
        addDependency(authCoordinator, autoremove: false)
        router.present(container: authRouter, animated: true)
    }

    private func showProfile() {
        let profileCoordinator = ProfileCoordinator(with: router, context: context)
        profileCoordinator.onLogout = { [weak self] in
            self?.context.auth.logout(completion: { error in
                guard error == nil else {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    SVProgressHUD.dismiss(withDelay: 3.0)
                    return
                }

                self?.menuCoordinator.restart()
            })
        }
        addDependency(profileCoordinator)
        profileCoordinator.start()
    }
}
