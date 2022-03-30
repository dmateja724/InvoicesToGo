//
//  AddItemController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/21/21.
//

import UIKit

protocol AddItemControllerDelegate: AnyObject {
    func addButtonPressed(item: Item)
}

class AddItemController: UIViewController {
    // MARK: - Properties

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var rateTextField: UITextField!

    weak var delegate: AddItemControllerDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    // MARK: - Actions

    @IBAction func addButtonPressed(_ sender: UIButton) {
        let name = nameTextField.text
        let quantity = Int(quantityTextField.text!) ?? 0
        let rate = Double(rateTextField.text!) ?? 0.0

        let dictionary: [String: Any] = ["name": name!,
                                         "quantity": quantity,
                                         "rate": rate]

        let item = Item(dictionary: dictionary)
        delegate?.addButtonPressed(item: item)

        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
