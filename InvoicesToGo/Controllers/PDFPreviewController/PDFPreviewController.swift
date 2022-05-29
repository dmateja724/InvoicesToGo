//
//  PDFPreviewController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 1/3/22.
//

import MessageUI
import PDFKit
import UIKit

class PDFPreviewController: UIViewController {
    // MARK: - Properties

    @IBOutlet var pdfView: PDFView!

    var viewModel: PDFPreviewViewModel?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send Email", style: .done, target: self, action: #selector(sendEmailTapped))
        super.viewDidLoad()
        generateInvoicePDF()
    }

    // MARK: - Actions

    @objc func sendEmailTapped() {
        sendEmail()
    }

    // MARK: - Helpers

    func generateInvoicePDF() {
        guard let viewModel = viewModel else { return }
        var counter = 0

        pdfView.document = PDFDocument()

        while counter <= viewModel.totalPageCount {
            let pdfDocument = PDFDocument(data: generatePDFDocument(invoice: viewModel.invoice, user: viewModel.user))
            let page = pdfDocument?.page(at: 0)

            pdfView.document?.insert(page!, at: counter)
            counter += 1
        }
        pdfView.autoScales = true

        viewModel.pageCount = 1
    }

    func generatePDFDocument(invoice: Invoice, user: User) -> Data {
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

            let headerAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)]
            let header = user.companyName
            currentY += 20
            header.draw(at: CGPoint(x: 20, y: currentY), withAttributes: headerAttributes)

            let ownerInfoAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)]
            let ownerInfo = "\(user.firstName) \(user.lastName) | \(user.email) | \(user.phoneNumber)"
            ownerInfo.draw(at: CGPoint(x: 25, y: currentY + 35), withAttributes: ownerInfoAttributes)

            let invoiceNumberAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
            let invoiceNumber = "Invoice #: \(invoice.invoiceNumber)"
            invoiceNumber.draw(at: CGPoint(x: 450, y: currentY + 10), withAttributes: invoiceNumberAttributes)

            let dateAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
            let date = todaysDate
            date.draw(at: CGPoint(x: 450, y: currentY + 40), withAttributes: dateAttributes)

            var clientInfoY = currentY + 70
            let clientInfoAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
            let fullName = invoice.clientInfo.fullName
            fullName.draw(at: CGPoint(x: 25, y: clientInfoY), withAttributes: clientInfoAttributes)

            let address1 = invoice.clientInfo.address1
            if !address1.isEmpty {
                clientInfoY += 15
                address1.draw(at: CGPoint(x: 25, y: clientInfoY), withAttributes: clientInfoAttributes)
            }

            let address2 = invoice.clientInfo.address2
            if !address2.isEmpty {
                clientInfoY += 15
                address2.draw(at: CGPoint(x: 25, y: clientInfoY), withAttributes: clientInfoAttributes)
            }

            if !invoice.clientInfo.city.isEmpty {
                clientInfoY += 15
                let cityStateZip = "\(invoice.clientInfo.city), \(invoice.clientInfo.state) \(invoice.clientInfo.zipCode)"
                cityStateZip.draw(at: CGPoint(x: 25, y: clientInfoY), withAttributes: clientInfoAttributes)
            }

            if !invoice.clientInfo.phoneNumber.isEmpty {
                clientInfoY += 17
                let phoneNumber = invoice.clientInfo.phoneNumber
                phoneNumber.draw(at: CGPoint(x: 25, y: clientInfoY), withAttributes: clientInfoAttributes)
            }
            
            var customerInfoY = currentY + 70
            let customerFullName = invoice.customerInfo.fullName
            customerFullName.draw(at: CGPoint(x: 300, y: customerInfoY), withAttributes: clientInfoAttributes)

            let customerAddress1 = invoice.customerInfo.address1
            if !customerAddress1.isEmpty {
                customerInfoY += 15
                customerAddress1.draw(at: CGPoint(x: 300, y: customerInfoY), withAttributes: clientInfoAttributes)
            }

            let customerAddress2 = invoice.customerInfo.address2
            if !customerAddress2.isEmpty {
                customerInfoY += 15
                customerAddress2.draw(at: CGPoint(x: 300, y: customerInfoY), withAttributes: clientInfoAttributes)
            }

            if !invoice.customerInfo.city.isEmpty {
                customerInfoY += 15
                let customerCityStateZip = "\(invoice.customerInfo.city), \(invoice.customerInfo.state) \(invoice.customerInfo.zipCode)"
                customerCityStateZip.draw(at: CGPoint(x: 300, y: customerInfoY), withAttributes: clientInfoAttributes)
            }

            if !invoice.customerInfo.phoneNumber.isEmpty {
                customerInfoY += 17
                let customerPhoneNumber = invoice.customerInfo.phoneNumber
                customerPhoneNumber.draw(at: CGPoint(x: 300, y: customerInfoY), withAttributes: clientInfoAttributes)
            }
            
            currentY += 180
            let headerLabelAtrributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
            let descriptionLabel = "Description"
            descriptionLabel.draw(at: CGPoint(x: 20, y: currentY), withAttributes: headerLabelAtrributes)

            let quantityLabel = "Quantity"
            quantityLabel.draw(at: CGPoint(x: 425, y: currentY), withAttributes: headerLabelAtrributes)

            let amountLabel = "Amount"
            amountLabel.draw(at: CGPoint(x: 525, y: currentY), withAttributes: headerLabelAtrributes)

            if let pageCount = viewModel?.pageCount,
               !invoice.items.isEmpty
            {
                let totalItemCount = pageCount * 20 > viewModel!.invoice.items.count ? (viewModel!.invoice.items.count - 1) : pageCount * 20
                let startItemCount = (pageCount - 1) * 20 > totalItemCount ? (pageCount * 20) - totalItemCount : (pageCount - 1) * 20
                var currentItemCount = startItemCount

                currentY += 50

                for item in invoice.items[startItemCount ... totalItemCount] {
                    if currentItemCount == startItemCount + 20 {
                        break
                    }
                    let itemsAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]

                    let itemDescription = item.name
                    itemDescription.draw(at: CGPoint(x: 25, y: currentY), withAttributes: itemsAttributes)

                    let itemQuantity = "\(item.quantity)"
                    itemQuantity.draw(at: CGPoint(x: 450, y: currentY), withAttributes: itemsAttributes)

                    let itemAmount = String(format: "%.2f", Double(item.quantity) * item.rate)
                    itemAmount.draw(at: CGPoint(x: 535, y: currentY), withAttributes: itemsAttributes)

                    currentY += 20
                    currentItemCount += 1
                }
            }

            let balanceDueAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
            let balanceDue = "Balance Due: $\(String(format: "%.2f", invoice.totalAmount))"
            balanceDue.draw(at: CGPoint(x: Int(pageWidth) - balanceDue.count * 12, y: Int(pageHeight) - 100), withAttributes: balanceDueAttributes)

            let pageNumberAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
            let pageNumberDescription = "Page \(viewModel!.pageCount)"
            pageNumberDescription.draw(at: CGPoint(x: 280, y: pageHeight - 50), withAttributes: pageNumberAttributes)
        }

        viewModel?.pageCount += 1
        return data
    }

    func sendEmail() {
        if let viewModel = viewModel {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([viewModel.invoice.clientInfo.email])
                mail.setSubject("\(viewModel.user.companyName): Invoice #\(viewModel.invoice.invoiceNumber) - \(viewModel.invoice.clientInfo.fullName)")

                var counter = 0
                while counter <= viewModel.totalPageCount {
                    mail.addAttachmentData(generatePDFDocument(invoice: viewModel.invoice, user: viewModel.user), mimeType: "application/pdf", fileName: "\(viewModel.user.companyName) Invoice - \(viewModel.invoice.clientInfo.fullName).pdf")
                    counter += 1
                }

                viewModel.pageCount = 1
                mail.setMessageBody("", isHTML: true)

                present(mail, animated: true)
            } else {
                showMessage(withTitle: "Error", message: "Email is not configured on this device. Please configure and try agian.")
            }
        } else {
            showMessage(withTitle: "Error", message: "Something went wrong.")
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension PDFPreviewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
