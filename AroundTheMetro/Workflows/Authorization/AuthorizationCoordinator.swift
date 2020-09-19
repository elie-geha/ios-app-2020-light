//  
//  AuthorizationCoordinator.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 10.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import SVProgressHUD
import UIKit

final class AuthorizationCoordinator: BaseCoordinator {
    var context: AppContext

    private var appleAuthController: Any?

    // MARK: -

    init(with router: RouterType, context: AppContext) {
        self.context = context
        super.init(with: router)
    }

    override func start() {
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
        authorizationCoordinatorVC.onLoginWithApple = {[weak self] in
            if #available(iOS 13, *) {
                self?.loginWithApple()
            }
        }
        router.show(container: authorizationCoordinatorVC, animated: true)
    }

    private func showRegistration() {
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

    @available(iOS 13, *)
    private func loginWithApple() {
        let appleAuthenticationController = AppleAuthorizationController()
        appleAuthenticationController.onDidAuthenticate = { [weak self] token, nonce in
            self?.context.auth.appleSignIn(with: token, nonce: nonce, completion: { result in
                switch result {
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    SVProgressHUD.dismiss(withDelay: 3.0)
                case .success:
                    self?.finish()
                }
            })
        }
        appleAuthenticationController.onDidFailAuthentication = { error in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            SVProgressHUD.dismiss(withDelay: 3.0)
        }

        appleAuthenticationController.startSignInWithAppleFlow()
        appleAuthController = appleAuthenticationController
    }
}
