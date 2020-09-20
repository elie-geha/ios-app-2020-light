//
//  RegistrationViewController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 13.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegistrationViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet var registerButton: UIButton!
    @IBOutlet var backButton: UIButton!

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!

    // MARK: - Properties

    // MARK: - Callbacks

    var onRegister: ((_ email: String, _ password: String) -> Void)?
    var onBack: EmptyCallback?

    // MARK: - Private variables

    // MARK: - LyfeCicle

    // MARK: - Actions

    @IBAction func register() {
        guard let (email, password) = validate() else {
            // show error!
            return
        }

        onRegister?(email, password)
    }

    @IBAction func back() {
        onBack?()
    }

    // MARK: - Private

    private func validate() -> (String, String)? {
        guard let email = emailTextField.text, let password = passwordTextField.text,
            let confirmation = confirmPasswordTextField.text,
            !email.isEmpty, !password.isEmpty, password == confirmation else {
                SVProgressHUD.showError(withStatus: "All fields are required. Passwords should match")
                SVProgressHUD.dismiss(withDelay: 3.0)
                return nil
        }

        return (email, password)
    }
}
