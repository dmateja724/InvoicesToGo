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
    @IBOutlet var signInButton: UIButton!

    var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateForm()
    }

    // MARK: - Actions

    @IBAction func textDidChange(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }

        updateForm()
    }

    @IBAction func signInButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else {
            return
        }

        AuthService.logUserIn(email: email, password: password) { _, error in
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                return
            }
            self.delegate?.authenticationDidComplete()
        }
    }

    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
        let viewController = ResetPasswordController()
        viewController.delegate = self
        viewController.email = emailTextField.text
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let viewController = SignUpController()
        viewController.delegate = delegate
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - ResetPasswordControllerDelegate

extension LoginController: ResetPasswordControllerDelegate {
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController) {
        navigationController?.popViewController(animated: true)
        showMessage(withTitle: "Success", message: "We sent a link to your email to reset your password.")
    }
}

// MARK: - FormViewModel

extension LoginController: FormViewModel {
    func updateForm() {
        signInButton.tintColor = viewModel.buttonBackgroundColor
        signInButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signInButton.isEnabled = viewModel.formIsValid
    }
}
