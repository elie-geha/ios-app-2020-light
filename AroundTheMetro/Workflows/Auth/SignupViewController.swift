//
//  SignupViewController.swift
//  AroundTheMetro
//
//  Created by Mansoor Ali on 07/07/2021.
//  Copyright © 2021 AugmentedDiscovery. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class SignupViewController: UIViewController {

	@IBOutlet weak var fullName: UITextField!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var password: UITextField!

	var showHome: (() -> Void)?
	let context = AppContext()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

	//MARK:- Actions
	@IBAction func signup() {
		let name = fullName.text ?? ""
		let email = self.email.text ?? ""
		let password = self.password.text ?? ""
		let result = validateFields(name: name, email: email, password: password)
		guard result else {return}

		//signup with firebase
		SVProgressHUD.show()
		Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
			guard let self = self else {return}
			if error != nil {
				SVProgressHUD.dismiss()
				SVProgressHUD.showError(withStatus: error?.localizedDescription ?? "")
			}else {
				self.updateUserName(fullName: name, email: email)
			}
		}
	}
	@IBAction func login() {
		self.navigationController?.popViewController(animated: true)
	}

	@IBAction func back() {
		self.navigationController?.popViewController(animated: true)
	}

	private func validateFields(name: String,email: String, password: String) -> Bool {
		let emailRegx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
		if name.isEmpty {
			SVProgressHUD.showError(withStatus: "Name is required")
			return false
		}else if !email.isValid(forExp: emailRegx) {
			SVProgressHUD.showError(withStatus: "Invaled Email ID")
			return false
		}else if password.count < 8 {
			SVProgressHUD.showError(withStatus: "Password should be atleast 8 characters")
			return false
		}
		return true
	}

	private func updateUserName(fullName: String, email: String) {
		let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
		changeRequest?.displayName = fullName
		changeRequest?.commitChanges { [weak self] error in
			SVProgressHUD.dismiss()
			if error != nil {
				SVProgressHUD.showError(withStatus: error?.localizedDescription ?? "")
			}else {
				self?.context.analytics.trackEvent(with: .signup(email: email))
				self?.showHome?()
			}
		}
	}
}
