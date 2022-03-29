//
//  NewInvoiceController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/20/21.
//

import UIKit

protocol NewInvoiceControllerDelegate: AnyObject {
    func saveInvoicePressed(invoice: Invoice)
}

class NewInvoiceController: UIViewController {
    // MARK: - Properties

    @IBOutlet var tableView: UITableView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var invoiceNumberLabel: UILabel!
    @IBOutlet var totalAmountLabel: UILabel!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var addClientButton: UIButton!
    @IBOutlet var addCustomerButton: UIButton!

    private let reuseIdentifier = "ItemCell"
    weak var delegate: NewInvoiceControllerDelegate?
    var viewModel: NewInvoiceViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }

            if !viewModel.invoice.clientInfo.fullName.isEmpty {
                addClientButton.setTitle(viewModel.invoice.clientInfo.fullName, for: .normal)
                addClientButton.setImage(UIImage(), for: .normal)
            }

            if !viewModel.invoice.customerInfo.fullName.isEmpty {
                addCustomerButton.setTitle(viewModel.invoice.customerInfo.fullName, for: .normal)
                addCustomerButton.setImage(UIImage(), for: .normal)
            }

            tableViewHeight?.constant = CGFloat(viewModel.invoice.items.count * 65)
            tableView?.reloadData()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: - Actions

    @IBAction func addItemPressed(_ sender: UIButton) {
        let addItemVC = AddItemController()
        addItemVC.delegate = self
        present(addItemVC, animated: true, completion: nil)
    }

    @objc func saveTapped() {
        guard let invoice = viewModel?.invoice else { return }
        navigationController?.popViewController(animated: true)
        delegate?.saveInvoicePressed(invoice: invoice)
    }

    @IBAction func addClientPressed(_ sender: UIButton) {
        let viewController = AddClientController()
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }

    @IBAction func addCustomerPressed(_ sender: UIButton) {
        let viewController = AddClientController()
        viewController.delegate = self
        viewController.isCustomer = true
        present(viewController, animated: true, completion: nil)
    }

    // MARK: - Helpers

    func configure() {
        guard let invoice = viewModel?.invoice else { return }

        navigationItem.title = "New Invoice"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped))
        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = 65
        tableViewHeight.constant = CGFloat(invoice.items.count * 65)
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: CGFloat(invoice.items.count * 65))

        dateLabel.text = invoice.dateCreated
        invoiceNumberLabel.text = String(invoice.invoiceNumber)
        setTotalAmount()
    }

    func setTotalAmount() {
        guard let invoice = viewModel?.invoice else { return }
        var total = 0.0

        for item in invoice.items {
            total += item.rate * Double(item.quantity)
        }

        viewModel?.invoice.totalAmount = total

        let totalAmount = String(format: "%.2f", total)
        totalAmountLabel.text = "$\(totalAmount)"
    }
}

// MARK: - UITableViewDataSource

extension NewInvoiceController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let invoice = viewModel?.invoice else { return 0 }
        return invoice.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ItemCell
        guard let item = viewModel?.invoice.items[indexPath.item] else { return UITableViewCell() }
        cell.configure(item: item)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NewInvoiceController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - AddItemControllerDelegate

extension NewInvoiceController: AddItemControllerDelegate {
    func addButtonPressed(item: Item) {
        viewModel?.invoice.items.append(item)
        setTotalAmount()
    }
}

// MARK: - AddClientControllerDelegate

extension NewInvoiceController: AddClientControllerDelegate {
    func addButtonPressed(client: Client, isCustomer: Bool) {
        if isCustomer {
            viewModel?.invoice.customerInfo = client
        } else {
            viewModel?.invoice.clientInfo = client
        }
    }
}
