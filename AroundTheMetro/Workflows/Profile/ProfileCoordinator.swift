//  
//  ProfileCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 13.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

final class ProfileCoordinator: BaseCoordinator {
    var context: AppContext

    var onLogout: (() -> Void)?

    // MARK: -

    init(with router: RouterType, context: AppContext) {
        self.context = context
        super.init(with: router)
    }

    override func start() {
        let profileVC = Storyboard.Profile.profileVC
        profileVC.onLogout = { [weak self] in
            self?.onLogout?()
            self?.finish()
        }
        initialContainer = profileVC
        router.show(container: profileVC, animated: true)
    }
}
