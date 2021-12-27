//
//  ResetPasswordController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/27/21.
//

import UIKit

protocol ResetPasswordControllerDelegate: AnyObject {
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController)
}

class ResetPasswordController: UIViewController {
    // MARK: - Properties

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var resetPasswordButton: UIButton!

    private var viewModel = ResetPasswordViewModel()
    weak var delegate: ResetPasswordControllerDelegate?
    var email: String?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: - Helpers

    func configure() {
        viewModel.email = email
        emailTextField.text = email
        updateForm()
    }

    // MARK: - Actions

    @IBAction func textDidChange(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }

        updateForm()
    }

    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        AuthService.resetPassword(withEmail: email) { error in
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                return
            }

            self.delegate?.controllerDidSendResetPasswordLink(self)
        }
    }
}

// MARK: - FormViewModel

extension ResetPasswordController: FormViewModel {
    func updateForm() {
        resetPasswordButton.tintColor = viewModel.buttonBackgroundColor
        resetPasswordButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        resetPasswordButton.isEnabled = viewModel.formIsValid
    }
}
