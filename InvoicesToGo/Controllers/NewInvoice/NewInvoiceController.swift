//
//  NewInvoiceController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/20/21.
//

import UIKit

class NewInvoiceController: UIViewController {
    // MARK: - Properties
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var invoiceNumberLabel: UILabel!
    
    var viewModel: NewInvoiceViewModel?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: - Actions
    
    @IBAction func addItemPressed(_ sender: UIButton) {
        let addItemVC = AddItemController()
        addItemVC.delegate = self
        present(addItemVC, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        navigationItem.title = "New Invoice"
        tableView.delegate = self
        tableView.dataSource = self
        
        dateLabel.text = viewModel.date
        invoiceNumberLabel.text = String(viewModel.invoiceNumber)
    }
}

// MARK: - UITableViewDataSource

extension NewInvoiceController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.width, height: 50))
        label.text = "item\(indexPath.item)"
        cell.addSubview(label)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NewInvoiceController: UITableViewDelegate {}


// MARK: - AddItemControllerDelegate

extension NewInvoiceController: AddItemControllerDelegate {
    func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    func addButtonPressed() {
        print("add button pressed")
    }
}
