//
//  AppleAuthorizationController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation
import AuthenticationServices

enum AppleAuthError: Error {
    case completedWithError(String)
    case failed(String)
}

@available(iOS 13, *)
class AppleAuthorizationController: NSObject {
    var onDidAuthenticate: ((_ token: String, _ nonce: String) -> Void)?
    var onDidFailAuthentication: ((Error) -> Void)?

    // Unhashed nonce.
    fileprivate var currentNonce: String?

    var authController: ASAuthorizationController?

    func startSignInWithAppleFlow() {
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
extension AppleAuthorizationController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                onDidFailAuthentication?(
                    AppleAuthError.completedWithError(
                        "Invalid state: A login callback was received, but no login request was sent."
                    )
                )
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                onDidFailAuthentication?(
                    AppleAuthError.completedWithError(
                        "Unable to fetch identity token"
                    )
                )
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                onDidFailAuthentication?(
                    AppleAuthError.completedWithError(
                        "Unable to serialize token string from data: \(appleIDToken.debugDescription)"
                    )
                )

                return
            }

            onDidAuthenticate?(idTokenString, nonce)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        onDidFailAuthentication?(AppleAuthError.failed(error.localizedDescription))
    }
}

@available(iOS 13.0, *)
extension AppleAuthorizationController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow ?? UIWindow()
    }
}

