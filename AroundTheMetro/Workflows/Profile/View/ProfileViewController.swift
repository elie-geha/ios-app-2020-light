//  
//  ProfileViewController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 13.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit

public final class ProfileViewController: UIViewController {
    // MARK: - Outlets

    // MARK: - Properties

    // MARK: - Callbacks

    var onLogout: (() -> Void)?

    // MARK: - Private variables

    // MARK: - LyfeCicle

    // MARK: - Actions

    @IBAction func logout() {
        onLogout?()
    }

    // MARK: - Private
}
