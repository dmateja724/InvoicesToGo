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
    @IBOutlet weak var signUpButton: UIButton!
    
    var viewModel = SignUpViewModel()
    weak var delegate: AuthenticationDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateForm()
    }

    // MARK: - Actions
    @IBAction func textDidChange(_ sender: UITextField) {
        if sender == firstNameTextField {
            viewModel.firstName = sender.text
        } else if sender == lastNameTextField {
            viewModel.lastName = sender.text
        } else if sender == companyNameTextField {
            viewModel.companyName = sender.text
        } else if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }

        updateForm()
    }
    
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
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                return
            }

            self.delegate?.authenticationDidComplete()
        }
    }
}

// MARK: - FormViewModel

extension SignUpController: FormViewModel {
    func updateForm() {
        signUpButton.tintColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signUpButton.isEnabled = viewModel.formIsValid
    }
}
