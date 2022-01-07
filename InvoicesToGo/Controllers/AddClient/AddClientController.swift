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

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    weak var delegate: AddClientControllerDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions

    @IBAction func addButtonPressed(_ sender: UIButton) {
        guard let name = nameTextField.text,
              let phone = phoneTextField.text,
              let email = emailTextField.text,
              let address1 = address1TextField.text,
              let address2 = address2TextField.text,
              let city = cityTextField.text,
              let state = stateTextField.text,
              let zipCode = zipCodeTextField.text,
              !name.isEmpty,
              !phone.isEmpty
        else {
            showMessage(withTitle: "Missing Fields", message: "Please fill in the name and phone number for the client")
            return
        }

        let dictionary: [String: Any] = ["fullName": name,
                                         "phoneNumber": phone,
                                         "email": email,
                                         "address1": address1,
                                         "address2": address2,
                                         "city": city,
                                         "state": state,
                                         "zipCode": zipCode]

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
