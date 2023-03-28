//
//  AddItemController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/21/21.
//

import UIKit

protocol AddItemControllerDelegate: AnyObject {
    func addButtonPressed(item: Item, indexPath: IndexPath?)
}

class AddItemController: UIViewController {
    // MARK: - Properties

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var rateTextField: UITextField!

    weak var delegate: AddItemControllerDelegate?
    var item: Item?
    var selectedIndex: IndexPath?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setItem()
    }
    
    //MARK: - Helpers
    
    private func setItem() {
        guard let item = item else {
            return
        }

        nameTextField.text = item.name
        quantityTextField.text = "\(item.quantity)"
        rateTextField.text = "\(Int(item.rate))"
    }

    // MARK: - Actions

    @IBAction func addButtonPressed(_ sender: UIButton) {
        let name = nameTextField.text
        let quantity = Double(quantityTextField.text!) ?? 0.0
        let rate = Double(rateTextField.text!) ?? 0.0
        

        let dictionary: [String: Any] = ["name": name!,
                                         "quantity": quantity,
                                         "rate": rate]

        let item = Item(dictionary: dictionary)
        delegate?.addButtonPressed(item: item, indexPath: selectedIndex)

        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
