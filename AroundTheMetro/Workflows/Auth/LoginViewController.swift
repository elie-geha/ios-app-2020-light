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

class LoginViewController: UIViewController {

	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var password: UITextField!

	var showHome: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
				SVProgressHUD.showError(withStatus: error?.localizedDescription ?? "")
			}else {
				self.showHome?()
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

	}

	@IBAction func loginWithGoogle() {

	}
	@IBAction func loginWithApple() {

	}

	//MARK:- Navigation
	@IBAction func signup() {
		guard let signup = UIStoryboard(name: "Auth", bundle: .main).instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController else {return}
		signup.showHome = self.showHome
		self.navigationController?.pushViewController(signup, animated: true)
	}
}

public extension String {

	func isValid(forExp exp: String) -> Bool {
		guard let test = NSPredicate(format:"SELF MATCHES %@", exp) as NSPredicate? else { return false }
		return test.evaluate(with: self)
	}
}
