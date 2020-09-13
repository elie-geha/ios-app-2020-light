//  
//  ProfileCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 13.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

public final class ProfileCoordinator: CoordinatorType {
    var router: RouterType
    var initialContainer: ContainerType?
    var onComplete: ((Bool) -> Void)?

    var onLogout: (() -> Void)?

    // MARK: -

    init(with router: RouterType) {
        self.router = router
    }

    func start() {
        let profileVC = Storyboard.Profile.profileVC
        profileVC.onLogout = { [weak self] in
            self?.onLogout?()
            self?.finish()
        }
        initialContainer = profileVC
        router.show(container: profileVC, animated: true)
    }
}
