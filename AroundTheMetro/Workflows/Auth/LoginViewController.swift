//
//  LoginViewController.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 07/07/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAuth
import FBSDKCoreKit

class LoginViewController: UIViewController {

	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var password: UITextField!

	var showHome: (() -> Void)?

	let context = AppContext()

    override func viewDidLoad() {
        super.viewDidLoad()

		email.delegate = self
		password.delegate = self
    }

	//MARK:-
	//MARK:- Actions
	@IBAction func login() {
		let email = self.email.text ?? ""
		let password = self.password.text ?? ""
		let result = validateFields(email: email, password: password)
		guard result else {return}

		//login with firebase
		SVProgressHUD.show()
		Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
			SVProgressHUD.dismiss()
			guard let self = self else {return}
			if error != nil {
				self.context.analytics.trackEvent(with: .login(email: email))
				SVProgressHUD.showError(withStatus: error?.localizedDescription ?? "")
			}else {
				self.showHome?()
				self.postLoginNotification()
			}
		}
	}

	private func validateFields(email: String, password: String) -> Bool {
		let emailRegx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
		if !email.isValid(forExp: emailRegx) {
			SVProgressHUD.showError(withStatus: "Invaled Email ID")
			return false
		}else if password.count < 8 {
			SVProgressHUD.showError(withStatus: "Password should be atleast 8 characters")
			return false
		}
		return true
	}

	@IBAction func loginWithFacebook() {
		SocialLoginManager.shared.getFacbookSigninToken(viewController: self) { [weak self] (result) in
			switch result {
			case .success(let token):
				self?.context.analytics.trackEvent(with: .facebookLogin)
				SVProgressHUD.show()
				let credential = FacebookAuthProvider
				  .credential(withAccessToken: token/*AccessToken.current!.tokenString*/)
				self?.authenticateFacebook(credential: credential) { [weak self] in
					SVProgressHUD.dismiss()
					self?.showHome?()
					self?.postLoginNotification()
				}
			case .failure(let error):
				SVProgressHUD.showError(withStatus: error.localizedDescription)
			}
		}
	}

	@IBAction func loginWithGoogle() {
		SocialLoginManager.shared.getGoogleSigninToken(viewController: self) { [weak self] (result) in
			switch result {
			case .success(let authentication):
				let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
																 accessToken: authentication.accessToken)
				SVProgressHUD.show()
				self?.authenticateGoogle(credential: credential, completion: { [weak self] in
					self?.context.analytics.trackEvent(with: .googleLogin)
					SVProgressHUD.dismiss()
					self?.showHome?()
					self?.postLoginNotification()
				})
			case .failure(let error):
				SVProgressHUD.showError(withStatus: error.localizedDescription)
			}
		}
	}

	private func postLoginNotification() {
		NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Constants.LOGIN_UPDATED)))
	}
	@IBAction func loginWithApple() {
		if #available(iOS 13.0, *) {
			SocialLoginManager.shared.getAppleToken { [weak self] (result) in
				switch result {
				case .success(let result):
					guard let idToken = result.tokenData else {return}
					let credential = OAuthProvider.credential(withProviderID: "apple.com",
															  idToken: idToken,
															  rawNonce: result.nounce)
					self?.loginWithAppleApi(credential: credential)
				case .failure(let error):
					SVProgressHUD.showError(withStatus: error.localizedDescription)
				}
			}
		} else {
			// Fallback on earlier versions
			SVProgressHUD.showInfo(withStatus: "Login with apple is available for iOS 13 and later")
		}
	}

	private func loginWithAppleApi(credential: OAuthCredential) {
		authenticateApple(credential: credential) { [weak self] (result) in
			switch result {
			case .success(_):
				self?.context.analytics.trackEvent(with: .appleLogin)
				self?.showHome?()
				self?.postLoginNotification()
			case .failure(let error):
				SVProgressHUD.showError(withStatus: error.localizedDescription)
			}
		}
	}

	//MARK:- Navigation
	@IBAction func signup() {
		guard let signup = UIStoryboard(name: "Auth", bundle: .main).instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController else {return}
		signup.showHome = self.showHome
		self.navigationController?.pushViewController(signup, animated: true)
	}
}

extension LoginViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == email {
			password.becomeFirstResponder()
		}else if textField == password {
			textField.resignFirstResponder()
		}
		return true
	}
}
public extension String {

	func isValid(forExp exp: String) -> Bool {
		guard let test = NSPredicate(format:"SELF MATCHES %@", exp) as NSPredicate? else { return false }
		return test.evaluate(with: self)
	}
}
