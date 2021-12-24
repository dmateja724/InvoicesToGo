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
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    private let reuseIdentifier = "ItemCell"
    weak var delegate: NewInvoiceControllerDelegate?
    var viewModel: NewInvoiceViewModel? {
        didSet {
            tableView?.reloadData()
        }
    }
    
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
    
    @objc func saveTapped() {
        guard let invoice = viewModel?.invoice else { return }
        navigationController?.popViewController(animated: true)
        delegate?.saveInvoicePressed(invoice: invoice)
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
        
        dateLabel.text = invoice.date
        invoiceNumberLabel.text = String(invoice.invoiceNumber)
        setTotalAmountLabel()
    }
    
    func setTotalAmountLabel() {
        guard var invoice = viewModel?.invoice else { return }
        var total = 0.0

        for item in invoice.items {
            total += item.rate * Double(item.quatity)
        }
        
        invoice.totalAmount = total
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
        guard let item = viewModel?.invoice.items[indexPath.item] else { return UITableViewCell()}
        cell.configure(item: item)
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

    func addButtonPressed(item: Item) {
        viewModel?.invoice.items.append(item)
        DispatchQueue.main.async {
            self.setTotalAmountLabel()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
