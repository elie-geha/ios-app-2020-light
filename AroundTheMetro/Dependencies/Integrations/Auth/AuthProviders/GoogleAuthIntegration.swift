//
//  GoogleAuthIntegration.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation
import GoogleSignIn
import Firebase

class GoogleAuthIntegration: NSObject, GoogleAuthIntegrationType {
    var completion: ((Result<(token: String, accessToken: String), ThirdPartyAuthError>) -> Void)?

    func signIn(in viewController: UIViewController?,
                completion: ((Result<(token: String, accessToken: String), ThirdPartyAuthError>) -> Void)?) {
        self.completion = completion

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = viewController
        GIDSignIn.sharedInstance().signIn()
    }
}

extension GoogleAuthIntegration: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        guard error == nil else {
            completion?(.failure(ThirdPartyAuthError.failed(error!.localizedDescription)))
            return
        }

        guard let authentication = user.authentication else { return }
        completion?(.success((token: authentication.idToken, accessToken: authentication.accessToken)))
    }
}
