//
//  AddItemController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/21/21.
//

import UIKit

protocol AddItemControllerDelegate: AnyObject {
    func cancelButtonPressed()
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
    }

    // MARK: - Actions

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        delegate?.cancelButtonPressed()
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        let name = nameTextField.text
        let quantity = Int(quantityTextField.text!) ?? 0
        let rate = Double(rateTextField.text!) ?? 0.0

        let item = Item(name: name!, quatity: quantity, rate: rate)

        delegate?.addButtonPressed(item: item)
    }
}
