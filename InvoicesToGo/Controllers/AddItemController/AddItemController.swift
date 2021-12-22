//
//  AddItemController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/21/21.
//

import UIKit

protocol AddItemControllerDelegate: AnyObject {
    func cancelButtonPressed()
    func addButtonPressed()
}

class AddItemController: UIViewController {
    // MARK: - Properties

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
        delegate?.addButtonPressed()
    }
}
