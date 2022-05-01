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
            refreshUI()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchInvoices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchInvoices()
    }

    // MARK: - Actions

    @objc func pressedCreateInvoiceButton() {
        guard let viewModel = viewModel else {
            return
        }

        let viewController = NewInvoiceController()
        let newInvoice = generateInvoice()
        viewController.viewModel = NewInvoiceViewModel(user: viewModel.user, invoice: newInvoice)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - API

    func fetchInvoices() {
        guard let viewModel = viewModel else {
            return
        }

        InvoiceService.fetchInvoices(forUser: viewModel.user.uid) { invoices in
            self.viewModel?.invoices = invoices
        }
    }

    // MARK: - Helpers

    func generateInvoice() -> Invoice {
        let invoiceNumber = viewModel!.invoices.count + 1

        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let formattedDate = dateFormatter.string(from: date)

        let dictionary: [String: Any] = ["uid": NSUUID().uuidString,
                                         "invoiceNumber": invoiceNumber,
                                         "dateCreated": formattedDate,
                                         "companyName": viewModel!.user.companyName,
                                         "ownerUid": viewModel!.user.uid]

        let invoice = Invoice(dictionary: dictionary)

        return invoice
    }

    func configure() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 72

        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(pressedCreateInvoiceButton))
        barButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        navigationItem.rightBarButtonItem = barButtonItem
        refreshUI()
    }

    func refreshUI() {
        guard let viewModel = viewModel else {
            return
        }

        tableView?.isHidden = viewModel.invoices.isEmpty
        noInvoicesLabel?.isHidden = !viewModel.invoices.isEmpty
        tableView?.reloadData()
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
        guard let viewModel = viewModel else { return }

        let viewController = NewInvoiceController()
        let invoice = viewModel.invoices[indexPath.item]
        viewController.viewModel = NewInvoiceViewModel(user: viewModel.user, invoice: invoice)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let invoices = viewModel?.invoices else { return }
            let invoiceID = invoices[indexPath.item].uid

            InvoiceService.deleteInvoice(invoiceID: invoiceID) { error in
                if let error = error {
                    self.showMessage(withTitle: "Error", message: error.localizedDescription)
                    return
                }

                self.viewModel?.invoices.remove(at: indexPath.item)
                tableView.reloadData()
            }
        }
    }
}

// MARK: - NewInvoiceControllerDelegate

extension InvoicesController: NewInvoiceControllerDelegate {
    func saveInvoicePressed(invoice: Invoice) {
        InvoiceService.saveInvoice(invoice: invoice) { _ in
            print("DEBUG: save invoice complete")
        }

        viewModel?.invoices.append(invoice)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
