//
//  MainCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 17.08.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit
import AKSideMenu

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
    private var contactUsRouter: UINavigationController!

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
        menuCoordinator = MenuCoordinator(with: menuCoordinatorRouter)
        menuCoordinator.onHome = { [weak self] in
            self?.sideMenuController?.hideMenuViewController()
            self?.sideMenuController?.contentViewController = self?.homeCoordinatorRouter
        }
        menuCoordinator.onChangeCity = { [weak self] in
            self?.sideMenuController?.hideMenuViewController()
            self?.sideMenuController?.contentViewController = self?.changeCityRouter
        }
        menuCoordinator.onContactUs = { [weak self] in
            self?.sideMenuController?.hideMenuViewController()
            self?.sideMenuController?.contentViewController = self?.contactUsRouter
        }
        menuCoordinator.start()
    }

    private func createChangeCity() {
        let changeCityVC = UIViewController() // instantiate from storyboard
        changeCityRouter = UINavigationController(rootViewController: changeCityVC)
    }

    private func createContactUs() {
        let contactUsVC = UIViewController() // instantiate from storyboard
        contactUsRouter = UINavigationController(rootViewController: contactUsVC)
    }

    private func createShare() {
        let shareVC = UIViewController() // instantiate from storyboard
        shareRouter = UINavigationController(rootViewController: shareVC)
    }
}
