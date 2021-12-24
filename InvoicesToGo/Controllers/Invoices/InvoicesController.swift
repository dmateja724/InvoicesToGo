//
//  InvoicesController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/20/21.
//

import UIKit

class InvoicesController: UIViewController {
    // MARK: - Properties

    @IBOutlet var tableView: UITableView!
    
    private let reuseIdentifier = "InvoiceCell"
    var invoices = [Invoice]()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: - Helpers

    func configure() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 72
        
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(pressedCreateInvoiceButton))
        barButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func pressedCreateInvoiceButton() {
        let viewController = NewInvoiceController()
        // TODO: - dynamically set invoice number
        // TODO: - move date stuff to extension
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let newInvoice = Invoice(invoiceNumber: 1, date: dateFormatter.string(from: date), items: [Item](), totalAmount: 0.0)
        viewController.viewModel = NewInvoiceViewModel(invoice: newInvoice)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension InvoicesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        invoices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! InvoiceCell
        cell.configure()
        return cell
    }
}

// MARK: - UITableViewDelegate

extension InvoicesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension InvoicesController: NewInvoiceControllerDelegate {
    func saveInvoicePressed(invoice: Invoice) {
        invoices.append(invoice)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
