//
//  LoginController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/26/21.
//

import UIKit

protocol AuthenticationDelegate: AnyObject {
    func authenticationDidComplete()
}

class LoginController: UIViewController {
    // MARK: - Properties

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    weak var delegate: AuthenticationDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions

    @IBAction func signInButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else {
            return
        }
        
        AuthService.logUserIn(email: email, password: password) { _, error in
            if let error = error {
                print("DEBUG: Fialed to log user in \(error.localizedDescription)")
                return
            }
            self.delegate?.authenticationDidComplete()
        }
    }

    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        print("DEBUG: forgot password button pressed")
    }

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let viewController = SignUpController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
