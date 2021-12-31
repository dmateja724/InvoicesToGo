//
//  AddClientController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/30/21.
//

import UIKit

protocol AddClientControllerDelegate: AnyObject {
    func addButtonPressed(client: Client)
}

class AddClientController: UIViewController {
    // MARK: - Properties

    @IBOutlet var clientNameTextField: UITextField!
    @IBOutlet var clientPhoneTextField: UITextField!
    @IBOutlet var clientEmailTextField: UITextField!

    weak var delegate: AddClientControllerDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions

    @IBAction func addButtonPressed(_ sender: UIButton) {
        guard let clientName = clientNameTextField.text,
              let clientPhone = clientPhoneTextField.text,
              let clientEmail = clientEmailTextField.text,
              !clientName.isEmpty,
              !clientPhone.isEmpty
        else {
            showMessage(withTitle: "Missing Fields", message: "Please fill in the name and phone number for the client")
            return
        }

        let dictionary: [String: Any] = ["fullName": clientName,
                                         "phoneNumber": clientPhone,
                                         "email": clientEmail]

        let client = Client(dictionary: dictionary)
        delegate?.addButtonPressed(client: client)

        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
