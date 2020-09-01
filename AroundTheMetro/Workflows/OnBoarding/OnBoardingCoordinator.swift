//
//  OnBoardingCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 01.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

class OnBoardingCoordinator: CoordinatorType {
    // MARK: - Context
    private var context: AppContext

    // MARK: - Navigation
    private var router: UIViewController

    // MARK: - Actions

    var onComplete: (() -> Void)?

    // MARK: -

    init(with router: UIViewController,
         context: AppContext) {
        self.router = router
        self.context = context
    }

    func start() {
        let onBoardingVC = Storyboard.OnBoarding.onBoardingVC
        onBoardingVC.steps = [.discover, .locate, .offlineMap, .stayTuned]
        onBoardingVC.onFinish = { [weak self] in
            self?.onComplete?()
            onBoardingVC.dismiss(animated: true)
        }
        onBoardingVC.onSkip = { [weak self] in
            self?.onComplete?()
            onBoardingVC.dismiss(animated: true)
        }
        router.present(onBoardingVC, animated: true)
    }
}
