//
//  OnBoardingCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 01.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

class OnBoardingCoordinator: BaseCoordinator {
    // MARK: - Context
    private var context: AppContext

    // MARK: -

    init(with router: RouterType,
         context: AppContext) {
        self.context = context
        super.init(with: router)
    }

    override func start() {
        let onBoardingVC = Storyboard.OnBoarding.onBoardingVC
        initialContainer = onBoardingVC
        onBoardingVC.steps = [.discover, .locate, .offlineMap, .stayTuned]
        onBoardingVC.onFinish = { [weak self] in
            self?.onComplete?(true)
            self?.router.hide(container: onBoardingVC, animated: true)
        }
        onBoardingVC.onSkip = { [weak self] in
            self?.onComplete?(false)
            self?.router.hide(container: onBoardingVC, animated: true)
        }
        router.show(container: onBoardingVC, animated: true)
    }
}
