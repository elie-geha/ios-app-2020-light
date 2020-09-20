//
//  AuthIntegration+Facebook.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 20.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Foundation
import Firebase

extension AuthIntegration {
    func facebookSignIn(with token: String,
                        completion: ((Result<AuthUserInfo?, AuthError>) -> Void)?) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token)

        login(with: credential, completion: completion)
    }
}
