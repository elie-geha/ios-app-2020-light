//
//  AuthIntegration.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 10.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import Firebase

class AuthIntegration: AuthIntegrationType {
    var userInfo: AuthUserInfo? {
        guard let currentUser = Auth.auth().currentUser else { return nil }
        return AuthUserInfo(displayName: currentUser.displayName, photoURL: currentUser.photoURL)
    }

    var isAuthorized: Bool {
        return Auth.auth().currentUser != nil
    }

    func login(with email: String, password: String, completion: ((Result<AuthUserInfo?, AuthError>) -> Void)?) {
        guard !isAuthorized else {
            completion?(.failure(.alreadyLoggedIn))
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                completion?(.failure(.loginError(error?.localizedDescription ?? "Unknown error")))
                return
            }

            if result != nil {
                completion?(.success(self.userInfo))
            }
        }
    }

    func register(with email: String, password: String, completion: ((Result<AuthUserInfo?, AuthError>) -> Void)?) {
        guard !isAuthorized else {
            completion?(.failure(.alreadyLoggedIn))
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                completion?(.failure(.loginError(error?.localizedDescription ?? "Unknown error")))
                return
            }

            if result != nil, result?.credential != nil {
                completion?(.success(self.userInfo))
            }
        }
    }

    func logout(completion: ((Error?) -> Void)?) {
        guard isAuthorized else {
            return
        }

        do {
            try Auth.auth().signOut()
            completion?(nil)
        } catch {
            completion?(error)
        }
    }
}
