//
//  LoginController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/26/21.
//

import UIKit

class LoginController: UIViewController {
    // MARK: - Properties

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions

    @IBAction func signInButtonPressed(_ sender: UIButton) {
        print("DEBUG: sign in button pressed")
    }

    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        print("DEBUG: forgot password button pressed")
    }

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let viewController = SignUpController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
