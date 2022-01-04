//
//  InvoicesController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/20/21.
//

import PDFKit
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

    // MARK: - Actions

    @objc func pressedCreateInvoiceButton() {
        let viewController = NewInvoiceController()
        let newInvoice = generateInvoice()
        viewController.viewModel = NewInvoiceViewModel(invoice: newInvoice)
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

    func generatePDF(index: Int) -> Data {
        guard let viewModel = viewModel else {
            return Data()
        }

        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let todaysDate = dateFormatter.string(from: date)

        let format = UIGraphicsPDFRendererFormat()
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        var currentY = 0
        
        // 4
        let data = renderer.pdfData { context in
            // 5
            context.beginPage()
            // 6
            let headerAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 45)]
            let header = viewModel.user.companyName
            currentY += 20
            header.draw(at: CGPoint(x: 20, y: currentY), withAttributes: headerAttributes)

            let invoiceNumberAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)]
            let invoiceNumber = "Invoice #: \(viewModel.invoices[index].invoiceNumber)"
            currentY += 50
            invoiceNumber.draw(at: CGPoint(x: 25, y: currentY), withAttributes: invoiceNumberAttributes)

            let dateAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)]
            let date = "Date: \(todaysDate)"
            currentY += 30
            date.draw(at: CGPoint(x: 25, y: currentY), withAttributes: dateAttributes)

            currentY += 70
            for item in viewModel.invoices[index].items {
                let itemsAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
                let item = "Items: \(item.name): \(item.quantity) x \(item.rate)"
                item.draw(at: CGPoint(x: 25, y: currentY), withAttributes: itemsAttributes)
                currentY += 20
            }
            
            let balanceDueAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)]
            let balanceDue = "Balance Due: $\(String(format: "%.2f", viewModel.invoices[index].totalAmount))"
            balanceDue.draw(at: CGPoint(x: Int(pageWidth) - 300, y: Int(pageHeight) - 100), withAttributes: balanceDueAttributes)
        }

        return data
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
        let vc = PDFPreviewController()
        vc.viewModel = PDFPreviewViewModel()
        vc.viewModel?.documentData = generatePDF(index: indexPath.item)
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
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
