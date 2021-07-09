//
//  LoginViewController+Facbook.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 09/07/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAuth
import FBSDKCoreKit

//MARK:- Facebook Login
extension LoginViewController {

	func authenticateFacebook(credential: AuthCredential, completion: @escaping() -> Void) {
		Auth.auth().signIn(with: credential) { [weak self] authResult, error in
			if let error = error {
			  let authError = error as NSError
				if /*isMFAEnabled,*/ authError.code == AuthErrorCode.secondFactorRequired.rawValue {
					self?.handleMultiFactorUser(authError: authError)
				} else {
					SVProgressHUD.showError(withStatus: error.localizedDescription)
//				self.showMessagePrompt(error.localizedDescription)
				return
			  }
			  // ...
			  return
			}

			completion()
			// User is signed in
			// ...
		}
	}

	private func handleMultiFactorUser(authError: NSError) {
		// The user is a multi-factor user. Second factor challenge is required.
		let resolver = authError
			.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
		var displayNameString = ""
		for tmpFactorInfo in resolver.hints {
			displayNameString += tmpFactorInfo.displayName ?? ""
			displayNameString += " "
		}
		//showInputPromptForMultiFactorUser(resolver: resolver)
	}
/*
	private func showInputPromptForMultiFactorUser(resolver: MultiFactorResolver) {
		self.showTextInputPrompt(
			withMessage: "Select factor to sign in\n\(displayNameString)",
			completionBlock: { [weak self] (userPressedOK, displayName) in
				var selectedHint: PhoneMultiFactorInfo?
				for tmpFactorInfo in resolver.hints {
					if displayName == tmpFactorInfo.displayName {
						selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
					}
				}
				self?.verifyPhoneNumber(selectedHint: selectedHint, resolver: resolver)
			}
		)
	}

	private func verifyPhoneNumber(selectedHint: PhoneMultiFactorInfo?, resolver: MultiFactorResolver) {
		PhoneAuthProvider.provider()
			.verifyPhoneNumber(with: selectedHint!, uiDelegate: nil,
							   multiFactorSession: resolver
								.session) { verificationID, error in
				if error != nil {
					print(
						"Multi factor start sign in failed. Error: \(error.debugDescription)"
					)
				} else {
					self.showTextInputPrompt(
						withMessage: "Verification code for \(selectedHint?.displayName ?? "")",
						completionBlock: { userPressedOK, verificationCode in
							let credential: PhoneAuthCredential? = PhoneAuthProvider.provider()
								.credential(withVerificationID: verificationID!,
											verificationCode: verificationCode!)
							let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator
								.assertion(with: credential!)
							resolver.resolveSignIn(with: assertion!) { authResult, error in
								if error != nil {
									print(
										"Multi factor finanlize sign in failed. Error: \(error.debugDescription)"
									)
								} else {
									self.navigationController?.popViewController(animated: true)
								}
							}
						}
					)
				}
			}
	}*/
}


//MARK: Google Login
extension LoginViewController {
	func authenticateGoogle(credential: AuthCredential, completion: @escaping() -> Void) {
		Auth.auth().signIn(with: credential) { [weak self] authResult, error in
			if let error = error {
			  let authError = error as NSError
				if /*isMFAEnabled,*/ authError.code == AuthErrorCode.secondFactorRequired.rawValue {
					self?.handleMultiFactorUser(authError: authError)
				} else {
					SVProgressHUD.showError(withStatus: error.localizedDescription)
				return
			  }
			  // ...
			  return
			}
			completion()
		}
	}
}

extension LoginViewController {
	func authenticateApple(credential: AuthCredential, completion: @escaping(Result<Void,Error>) -> Void) {
		Auth.auth().signIn(with: credential) { (authResult, error) in
			if error != nil{
				// Error. If error.code == .MissingOrInvalidNonce, make sure
				// you're sending the SHA256-hashed nonce as a hex string with
				// your request to Apple.
				completion(.failure(error!))
				return
			}
			completion(.success(()))
			// User is signed in to Firebase with Apple.
			// ...
		}
	}
}
