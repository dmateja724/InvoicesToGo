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

        let data = renderer.pdfData { context in
            context.beginPage()

            let headerAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]
            let header = viewModel.user.companyName
            currentY += 20
            header.draw(at: CGPoint(x: 20, y: currentY), withAttributes: headerAttributes)

            let invoiceNumberAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
            let invoiceNumber = "Invoice #: \(viewModel.invoices[index].invoiceNumber)"
            invoiceNumber.draw(at: CGPoint(x: 450, y: currentY + 10), withAttributes: invoiceNumberAttributes)

            let dateAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
            let date = todaysDate
            date.draw(at: CGPoint(x: 450, y: currentY + 40), withAttributes: dateAttributes)
            
            let usersInfoAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
            let usersName = "\(viewModel.user.firstName) \(viewModel.user.lastName)"
            usersName.draw(at: CGPoint(x: 250, y: currentY + 70), withAttributes: usersInfoAttributes)
            
            let usersEmail = viewModel.user.email
            usersEmail.draw(at: CGPoint(x: 250, y: currentY + 90), withAttributes: usersInfoAttributes)
            
            let usersPhone = viewModel.user.phoneNumber
            usersPhone.draw(at: CGPoint(x: 250, y: currentY + 110), withAttributes: usersInfoAttributes)
            
            var clientInfoY = currentY + 50
            let clientInfoAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
            let fullName = viewModel.invoices[index].clientInfo.fullName
            fullName.draw(at: CGPoint(x: 25, y: clientInfoY), withAttributes: clientInfoAttributes)
            
            let address1 = viewModel.invoices[index].clientInfo.address1
            clientInfoY += 15
            address1.draw(at: CGPoint(x: 25, y: clientInfoY), withAttributes: clientInfoAttributes)
            
            let address2 = viewModel.invoices[index].clientInfo.address2
            if !address2.isEmpty {
                clientInfoY += 15
                address2.draw(at: CGPoint(x: 25, y: clientInfoY), withAttributes: clientInfoAttributes)
            }
            
            clientInfoY += 15
            let cityStateZip = "\(viewModel.invoices[index].clientInfo.city), \(viewModel.invoices[index].clientInfo.state) \(viewModel.invoices[index].clientInfo.zipCode)"
            cityStateZip.draw(at: CGPoint(x: 25, y: clientInfoY), withAttributes: clientInfoAttributes)
            
            clientInfoY += 17
            let phoneNumber = viewModel.invoices[index].clientInfo.phoneNumber
            phoneNumber.draw(at: CGPoint(x: 25, y: clientInfoY), withAttributes: clientInfoAttributes)

            currentY += 180
            let headerLabelAtrributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
            let descriptionLabel = "Description"
            descriptionLabel.draw(at: CGPoint(x: 20, y: currentY), withAttributes: headerLabelAtrributes)

            let quantityLabel = "Quantity"
            quantityLabel.draw(at: CGPoint(x: 325, y: currentY), withAttributes: headerLabelAtrributes)

            let rateLabel = "Rate"
            rateLabel.draw(at: CGPoint(x: 450, y: currentY), withAttributes: headerLabelAtrributes)

            let amountLabel = "Amount"
            amountLabel.draw(at: CGPoint(x: 525, y: currentY), withAttributes: headerLabelAtrributes)

            currentY += 70
            for item in viewModel.invoices[index].items {
                let itemsAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]

                let itemDescription = item.name
                itemDescription.draw(at: CGPoint(x: 25, y: currentY), withAttributes: itemsAttributes)

                let itemQuantity = "\(item.quantity)"
                itemQuantity.draw(at: CGPoint(x: 350, y: currentY), withAttributes: itemsAttributes)

                let itemRate = String(format: "%.2f", item.rate)
                itemRate.draw(at: CGPoint(x: 450, y: currentY), withAttributes: itemsAttributes)

                let itemAmount = String(format: "%.2f", Double(item.quantity) * item.rate)
                itemAmount.draw(at: CGPoint(x: 535, y: currentY), withAttributes: itemsAttributes)

                currentY += 20
            }

            let balanceDueAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)]
            let balanceDue = "Balance Due: $\(String(format: "%.2f", viewModel.invoices[index].totalAmount))"
            balanceDue.draw(at: CGPoint(x: Int(pageWidth) - balanceDue.count * 12, y: Int(pageHeight) - 100), withAttributes: balanceDueAttributes)
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
        vc.viewModel = PDFPreviewViewModel(documentData: generatePDF(index: indexPath.item))
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
