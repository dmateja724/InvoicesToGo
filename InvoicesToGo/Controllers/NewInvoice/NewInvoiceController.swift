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
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    let reuseIdentifier = "ItemCell"
    var viewModel: NewInvoiceViewModel? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setTotal()
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
        
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 65
        
        dateLabel.text = viewModel.date
        invoiceNumberLabel.text = String(viewModel.invoiceNumber)
    }
    
    func setTotal() {
        guard let viewModel = viewModel else { return }
        var total = 0.0

        viewModel.items.map { item in
            total += item.rate * Double(item.quatity)
        }
        
        totalAmountLabel.text = "$\(total)"
    }
}

// MARK: - UITableViewDataSource

extension NewInvoiceController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ItemCell
        guard let item = viewModel?.items[indexPath.item] else { return UITableViewCell()}
        
        cell.itemNameLabel.text = item.name
        cell.qtyAmountLabel.text = "\(item.quatity) x $\(item.rate)"
        cell.totalCostLabel.text = "$\(Double(item.quatity) * item.rate)"
        
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
        viewModel?.items.append(item)
        DispatchQueue.main.async {
            self.setTotal()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
