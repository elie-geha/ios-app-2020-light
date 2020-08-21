//
//  MainCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import AKSideMenu
import UIKit

class MainCoordinator {
    // MARK: - Repositories
    private var context: AppContext

    // MARK: - Navigation
    private var router: UINavigationController

    private var sideMenuController: AKSideMenu?

    private var homeCoordinator: HomeCoordinator!
    private var menuCoordinator: MenuCoordinator!

    private var homeCoordinatorRouter: UINavigationController!

    private var menuCoordinatorRouter: UINavigationController!
    private var changeCityRouter: UINavigationController!
    private var contactUsController: ContactUsController!

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
        if context.userStorageService.currentCity == nil && context.userStorageService.currentCountry == nil {
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
            self?.sideMenuController?.presentRightMenuViewController()
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
            self?.setContentViewController(self?.changeCityRouter)
        }
        menuCoordinator.onContactUs = { [weak self] in
            self?.showContactUs()
        }
        menuCoordinator.start()
    }

    private func createChangeCity() {
        let changeCityVC = UIViewController() // instantiate from storyboard
        changeCityRouter = UINavigationController(rootViewController: changeCityVC)
    }

    private func createContactUs() {
        contactUsController = ContactUsController()
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
}
