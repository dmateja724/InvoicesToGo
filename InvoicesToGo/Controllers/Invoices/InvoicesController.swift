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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: - Helpers

    func configure() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func pressedCreateInvoiceButton(_ sender: Any) {
        let viewController = NewInvoiceController()
        // TODO: - dynamically set invoice number
        // TODO: - move date stuff to extension
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        viewController.viewModel = NewInvoiceViewModel(invoiceNumber: 1, date: dateFormatter.string(from: date), items: [Item]())
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension InvoicesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension InvoicesController: UITableViewDelegate {}
