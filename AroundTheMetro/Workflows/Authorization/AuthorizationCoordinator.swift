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

    // MARK: -

    init(with router: RouterType, context: AppContext) {
        self.context = context
        super.init(with: router)
    }

    override func start() {
        let authorizationCoordinatorVC = StoryboardScene.Authorization.initialScene.instantiate()
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
            self?.loginWithApple()
        }
        authorizationCoordinatorVC.onLoginWithGoogle = {[weak self] in
            self?.loginWithGoogle()
        }
        router.show(container: authorizationCoordinatorVC, animated: true)
    }

    private func showRegistration() {
        let registrationVC = StoryboardScene.Authorization.registrationViewController.instantiate()
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

    private func loginWithApple() {
        let appleAuthIntegration = context.appleAuth

        appleAuthIntegration?.signIn( in: initialContainer?.asUIViewController()?.view.window) { [weak self] result in
                switch result {
                case .success(let authData):
                    self?.context.auth.appleSignIn(with: authData.token, nonce: authData.nonce, completion: { result in
                        switch result {
                        case .failure(let error):
                            SVProgressHUD.showError(withStatus: error.localizedDescription)
                            SVProgressHUD.dismiss(withDelay: 3.0)
                        case .success:
                            self?.finish()
                        }
                    })

                case .failure: break;
                }
            }
    }

    private func loginWithGoogle() {
        let googleAuthIntegration = context.googleAuth

        googleAuthIntegration.signIn( in: initialContainer?.asUIViewController()) { [weak self] result in
            switch result {
            case .success(let authData):
                self?.context.auth.googleSignIn(with: authData.token, accessToken: authData.accessToken, completion: { result in
                    switch result {
                    case .failure(let error):
                        SVProgressHUD.showError(withStatus: error.localizedDescription)
                        SVProgressHUD.dismiss(withDelay: 3.0)
                    case .success:
                        self?.finish()
                    }
                })

            case .failure: break;
            }
        }
    }
}
