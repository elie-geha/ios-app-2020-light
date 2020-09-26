//  
//  AuthorizationViewController.swift
//  AroundTheMetro
//
//  Created by Artem Alexandrov on 10.09.2020.
//  Copyright © 2020 AugmentedDiscovery. All rights reserved.
//

import SVProgressHUD
import UIKit

public final class AuthorizationViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!

    @IBOutlet var appleLoginButton: UIButton!

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    @IBOutlet var orContainer: UIView!
    @IBOutlet var orLabel: UILabel!

    // MARK: - Properties

    // MARK: - Callbacks

    var onBack: EmptyCallback?
    var onLogin: ((_ email: String, _ password: String) -> Void)?
    var onRegister: EmptyCallback?
    var onForgotPassword: EmptyCallback?

    var onLoginWithApple: EmptyCallback?
    var onLoginWithGoogle: EmptyCallback?
    var onLoginWithFacebook: EmptyCallback?

    // MARK: - Private variables

    // MARK: - LyfeCicle

    public override func viewDidLoad() {
        if #available(iOS 12, *) {
            backButton.isHidden = true
        }

        if #available(iOS 13, *) {
            appleLoginButton.isHidden = false
        } else {
            appleLoginButton.isHidden = true
        }

        orContainer.isHidden = appleLoginButton.isHidden
    }

    // MARK: - Actions

    @IBAction func back() {
        onBack?()
    }

    @IBAction func login() {
        guard let (email, password) = validate() else {
            // show error!
            return
        }

        onLogin?(email, password)
    }

    @IBAction func register() {
        onRegister?()
    }

    @IBAction func forgotPassword() {
        onForgotPassword?()
    }

    @IBAction func loginWithApple() {
        onLoginWithApple?()
    }

    @IBAction func loginWithGoogle() {
        onLoginWithGoogle?()
    }

    @IBAction func loginWithFacebook() {
        onLoginWithFacebook?()
    }

    // MARK: - Private

    private func validate() -> (String, String)? {
        guard let email = emailTextField.text, let password = passwordTextField.text,
            !email.isEmpty, !password.isEmpty else {
                SVProgressHUD.showError(withStatus: "Please fill in email and password")
                SVProgressHUD.dismiss(withDelay: 3.0)
                return nil
        }

        return (email, password)
    }
}
