//
//  SocialLoginManager.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 09/07/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import Foundation
//import FirebaseInstanceID
import Firebase
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices
import CryptoKit

protocol SocialLoginManagerDelegate: class {
	func googleResult(result: Result<(GIDAuthentication),Error>)
}

struct AppleLoginResult {
	let userIdentifier: String
	let fullName: PersonNameComponents?
	let email: String?
	let tokenData: String?
	let nounce: String
}

class SocialLoginManager: NSObject {
	static let shared = SocialLoginManager()
	weak var viewController: UIViewController!
	private var loginSuccessCallBack: (() -> Void)?
	weak var delegate: SocialLoginManagerDelegate?

	func configure(){
		self.configureGoogle()

		//MARK: FB SDK
//		ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
	}

	private func configureGoogle(){
		GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
		GIDSignIn.sharedInstance().delegate = self
	}

	//login user into facebook and get token
	public func getFacbookSigninToken(viewController: UIViewController, completion: @escaping(Result<String,Error>) -> Void){
		self.viewController = viewController
		if let token = AccessToken.current?.tokenString{
//			self.loginWithFacebook(token: token)
			completion(.success(token))
		} else{
			let loginManager = LoginManager()
			loginManager.logIn(permissions: [.publicProfile,.email], viewController: viewController) { (loginResult) in
				switch loginResult {
				case .failed(let error):
					completion(.failure(error))
				case .cancelled:
					print("User cancelled login.")
				case .success(let grantedPermissions, let declinedPermissions, let accessToken):
					let token = accessToken?.tokenString ?? ""
					completion(.success(token))
//					self.loginWithFacebook(token: token ?? "")
				}
			}
		}
	}

	var googleTokenCallback: ((Result<(GIDAuthentication),Error>) -> Void)?
	public func getGoogleSigninToken(viewController: UIViewController , completion: @escaping(Result<GIDAuthentication,Error>) -> Void){
		self.googleTokenCallback = completion
		self.viewController = viewController
		GIDSignIn.sharedInstance().presentingViewController = viewController
		GIDSignIn.sharedInstance().signIn()
	}

	fileprivate var currentNonce: String?
	private var appleLoginCallback: ((Result<AppleLoginResult, Error>) -> Void)?
	@available(iOS 13.0, *)
	func getAppleToken(callback: @escaping (Result<AppleLoginResult, Error>)-> Void) {
		appleLoginCallback = callback
		currentNonce = randomNonceString()
		let appleIDProvider = ASAuthorizationAppleIDProvider()
		let request = appleIDProvider.createRequest()
		request.requestedScopes = [.fullName, .email]
		request.nonce = sha256(currentNonce!)
		let authorizationController = ASAuthorizationController(authorizationRequests: [request])
		authorizationController.delegate = self
		authorizationController.performRequests()
	}

	@available(iOS 13, *)
	private func sha256(_ input: String) -> String {
	  let inputData = Data(input.utf8)
	  let hashedData = SHA256.hash(data: inputData)
	  let hashString = hashedData.compactMap {
		return String(format: "%02x", $0)
	  }.joined()

	  return hashString
	}
	
	// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
	private func randomNonceString(length: Int = 32) -> String {
	  precondition(length > 0)
	  let charset: Array<Character> =
		  Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
	  var result = ""
	  var remainingLength = length

	  while remainingLength > 0 {
		let randoms: [UInt8] = (0 ..< 16).map { _ in
		  var random: UInt8 = 0
		  let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
		  if errorCode != errSecSuccess {
			fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
		  }
		  return random
		}

		randoms.forEach { random in
		  if remainingLength == 0 {
			return
		  }

		  if random < charset.count {
			result.append(charset[Int(random)])
			remainingLength -= 1
		  }
		}
	  }

	  return result
	}
}

extension SocialLoginManager:GIDSignInDelegate{
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		if let error = error {
			if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
				print("The user has not signed in before or they have since signed out.")
			} else {
				print("\(error.localizedDescription)")
			}
			googleTokenCallback?(.failure(error))
			return
		}
		// Perform any operations on signed in user here.
		//        let userId = user.userID                  // For client-side use only!
		//        let idToken = user.authentication.idToken // Safe to send to the server
		//        let fullName = user.profile.name
		//        let givenName = user.profile.givenName
		//        let familyName = user.profile.familyName
		//        let email = user.profile.email
		//        print("Google sign in Token",user.authentication.idToken)
		googleTokenCallback?(.success(user.authentication))
		delegate?.googleResult(result: .success(user.authentication))
//		self.loginWithGoogle(token: user.authentication.idToken)

	}



	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
			  withError error: Error!) {
		// Perform any operations when the user disconnects from app here.
		// ...
		googleTokenCallback?(.failure(error))
	}
}

//MARK:-
extension SocialLoginManager: ASAuthorizationControllerDelegate {

	@available(iOS 13.0, *)
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
			let userIdentifier = appleIDCredential.user
			let fullName = appleIDCredential.fullName
			let email = appleIDCredential.email
			let tokenData = appleIDCredential.identityToken.map{String(data: $0, encoding: .utf8)} ?? nil
			let result = AppleLoginResult(userIdentifier: userIdentifier, fullName: fullName, email: email, tokenData: tokenData, nounce: currentNonce!)
			appleLoginCallback?(.success(result))
		}
//		appleLoginCallback?()
	}

	@available(iOS 13.0, *)
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		appleLoginCallback?(.failure(error))
	}
}
