//
//  AddClientController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/30/21.
//

import UIKit

protocol AddClientControllerDelegate: AnyObject {
    func addButtonPressed(client: Client, isCustomer: Bool)
}

class AddClientController: UIViewController {
    // MARK: - Properties

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var address1TextField: UITextField!
    @IBOutlet var address2TextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var zipCodeTextField: UITextField!

    weak var delegate: AddClientControllerDelegate?
    var isCustomer: Bool = false
    var client: Client?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        if isCustomer {
            headerLabel.text = "Add Customer"
        }

        setClientInfo()
    }

    // MARK: - Helpers

    private func setClientInfo() {
        guard let client = client else {
            return
        }

        nameTextField.text = client.fullName
        phoneTextField.text = client.phoneNumber
        emailTextField.text = client.email
        address1TextField.text = client.address1
        address2TextField.text = client.address2
        cityTextField.text = client.city
        stateTextField.text = client.state
        zipCodeTextField.text = client.zipCode
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
              !phone.isEmpty,
              !address1.isEmpty,
              !city.isEmpty,
              !state.isEmpty,
              !zipCode.isEmpty
        else {
            showMessage(withTitle: "Missing Fields", message: "Please fill in all fields that have a * next to their description")
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
        delegate?.addButtonPressed(client: client, isCustomer: isCustomer)

        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
