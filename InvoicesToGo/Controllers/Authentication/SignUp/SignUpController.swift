//
//  SignUpController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/26/21.
//

import UIKit

class SignUpController: UIViewController {
    // MARK: - Properties

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var companyNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    weak var delegate: AuthenticationDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard let firstName = firstNameTextField.text,
              let lasName = lastNameTextField.text,
              let companyName = companyNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text
        else {
            return
        }
        
        let credentials = AuthCredentials(firstName: firstName, lastName: lasName, companyName: companyName, email: email, password: password)

        AuthService.registerUser(withCredential: credentials) { error in
            if let error = error {
                print("DEBUG: Failed to register user \(error.localizedDescription)")
                return
            }

            self.delegate?.authenticationDidComplete()
        }
    }
}
