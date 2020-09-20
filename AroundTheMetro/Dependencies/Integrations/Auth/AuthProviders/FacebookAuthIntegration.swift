//
//  FacebookAuthIntegration.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 20.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookAuthIntegration: FacebookAuthIntegrationType {
    func signIn(in viewController: UIViewController?,
                completion: ((Result<String, ThirdPartyAuthError>) -> Void)?) {
        let loginManager = LoginManager()

        loginManager.logIn(permissions: ["public_profile", "email"],
                           from: viewController) { (result, error) in
            if error != nil {
                completion?(.failure(ThirdPartyAuthError.failed(error!.localizedDescription)))
            } else if result?.isCancelled == true {
                completion?(.failure(ThirdPartyAuthError.cancelled))
            } else if let tokenString = result?.token?.tokenString {
                completion?(.success(tokenString))
            } else {
                completion?(.failure(ThirdPartyAuthError.completedWithError("No token received")))
            }
        }
    }
}
