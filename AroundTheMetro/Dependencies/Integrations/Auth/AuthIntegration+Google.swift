//
//  AuthIntegration+Google.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 19.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Firebase

extension AuthIntegration {
    func googleSignIn(with idTokenString: String,
                      accessToken: String,
                      completion: ((Result<AuthUserInfo?, AuthError>) -> Void)?) {
        // Initialize a Google credential.
        let credential = GoogleAuthProvider.credential(withIDToken: idTokenString, accessToken: accessToken)

        // Sign in with Google.
        login(with: credential, completion: completion)
    }
}
