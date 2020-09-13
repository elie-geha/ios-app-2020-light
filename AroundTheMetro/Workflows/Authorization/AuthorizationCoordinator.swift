//  
//  AuthorizationCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 10.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import SVProgressHUD
import UIKit

public final class AuthorizationCoordinator: CoordinatorType {
    var router: RouterType
    var initialContainer: ContainerType?
    var onComplete: ((Bool) -> Void)?

    var context: AppContext

    // MARK: -

    init(with router: RouterType, context: AppContext) {
        self.router = router
        self.context = context
    }

    func start() {
        let authorizationCoordinatorVC = Storyboard.Authorization.authorizationVC
        initialContainer = authorizationCoordinatorVC
        authorizationCoordinatorVC.onBack = { [weak self] in
            self?.finish()
        }
        authorizationCoordinatorVC.onLogin = { [weak self] email, password in
            self?.context.auth.login(with: email, password: password) { result in
                switch result {
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    SVProgressHUD.dismiss(withDelay: 3.0)
                case .success:
                    self?.finish()
                }
            }
        }
        authorizationCoordinatorVC.onRegister = { [weak self] in
            self?.showRegistration()
        }
        authorizationCoordinatorVC.onForgotPassword = {
            // TODO
        }
        router.show(container: authorizationCoordinatorVC, animated: true)
    }

    func showRegistration() {
        let registrationVC = Storyboard.Authorization.registrationVC
        registrationVC.onRegister = { [weak self] email, password in
            self?.context.auth.register(with: email, password: password) { result in
                switch result {
                case .failure(let error):
                    let errorMessage: String
                    if case let .loginError(message) = error {
                        errorMessage = message
                    } else {
                        errorMessage = error.localizedDescription
                    }

                    SVProgressHUD.showError(withStatus: errorMessage)
                    SVProgressHUD.dismiss(withDelay: 3.0)
                case .success:
                    self?.finish()
                }
            }
        }
        registrationVC.onBack = { [weak self] in
            self?.router.hide(container: registrationVC, animated: true)
        }
        router.show(container: registrationVC, animated: true)
    }
}
