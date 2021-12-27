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
    @IBOutlet var noInvoicesLabel: UILabel!

    private let reuseIdentifier = "InvoiceCell"
    var viewModel: InvoicesViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }

            tableView?.isHidden = viewModel.invoices.isEmpty
            noInvoicesLabel?.isHidden = !viewModel.invoices.isEmpty
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: - Actions

    @objc func pressedCreateInvoiceButton() {
        guard let viewModel = viewModel else { return }
        let invoiceNumber = viewModel.invoices.count + 1

        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let formattedDate = dateFormatter.string(from: date)

        let viewController = NewInvoiceController()
        let newInvoice = Invoice(invoiceNumber: invoiceNumber, date: formattedDate, companyName: viewModel.user.companyName)
        viewController.viewModel = NewInvoiceViewModel(invoice: newInvoice)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
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
}

// MARK: - UITableViewDataSource

extension InvoicesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.invoices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! InvoiceCell
        guard let viewModel = viewModel else { return UITableViewCell() }
        cell.configure(invoice: viewModel.invoices[indexPath.item])
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
        viewModel?.invoices.append(invoice)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
