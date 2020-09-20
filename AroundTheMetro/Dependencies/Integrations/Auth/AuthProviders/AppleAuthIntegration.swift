//
//  AppleAuthorization.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation
import AuthenticationServices

@available(iOS 13, *)
class AppleAuthIntegration: NSObject, AppleAuthIntegrationType {
    var completion: ((Result<(token: String, nonce: String), ThirdPartyAuthError>) -> Void)?

    // Unhashed nonce.
    fileprivate var currentNonce: String?

    var authController: ASAuthorizationController?
    var window: UIWindow?

    func signIn(in window: UIWindow?,
                completion: ((Result<(token: String, nonce: String), ThirdPartyAuthError>) -> Void)?) {
        self.completion = completion
        self.window = window

        let nonce = AppleAuthorizationHelper.generateRandomNonce()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = AppleAuthorizationHelper.sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()

        authController = authorizationController
    }
}

@available(iOS 13.0, *)
extension AppleAuthIntegration: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                completion?(
                    .failure(ThirdPartyAuthError.completedWithError(
                        "Invalid state: A login callback was received, but no login request was sent."
                    ))
                )
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                completion?(
                    .failure(ThirdPartyAuthError.completedWithError(
                        "Unable to fetch identity token"
                    ))
                )
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                completion?(
                    .failure(ThirdPartyAuthError.completedWithError(
                        "Unable to serialize token string from data: \(appleIDToken.debugDescription)"
                    ))
                )

                return
            }

            completion?(.success((token: idTokenString, nonce: nonce)))
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        completion?(.failure(ThirdPartyAuthError.failed(error.localizedDescription)))
    }
}

@available(iOS 13.0, *)
extension AppleAuthIntegration: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window ?? UIWindow()
    }
}

