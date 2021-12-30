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
    
    private let reuseIdentifier = "ItemCell"
    weak var delegate: NewInvoiceControllerDelegate?
    var viewModel: NewInvoiceViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
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
        present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Helpers

    func configure() {
        guard let invoice = viewModel?.invoice else { return }

        navigationItem.title = "New Invoice"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped))
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 65
      
        tableViewHeight.constant = CGFloat(invoice.items.count * 65)
        
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: CGFloat(invoice.items.count * 65))

        
        dateLabel.text = invoice.date
        invoiceNumberLabel.text = String(invoice.invoiceNumber)
        setTotalAmount()
    }

    func setTotalAmount() {
        guard let invoice = viewModel?.invoice else { return }
        var total = 0.0

        for item in invoice.items {
            total += item.rate * Double(item.quatity)
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
    func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    func addButtonPressed(item: Item) {
        viewModel?.invoice.items.append(item)
        setTotalAmount()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
