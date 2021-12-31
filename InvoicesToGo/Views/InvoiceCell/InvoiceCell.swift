//
//  InvoiceCell.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/23/21.
//

import UIKit

class InvoiceCell: UITableViewCell {
    // MARK: - Properties

    @IBOutlet var invoiceHeaderLabel: UILabel!
    @IBOutlet var invoiceInfoLabel: UILabel!
    @IBOutlet var totalAmountLabel: UILabel!
    @IBOutlet var checkMarkImage: UIImageView!
    @IBOutlet var printButton: UIButton!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Helpers

    @IBAction func printInvoicePressed(_ sender: UIButton) {
        print("print invoice here")
    }

    // MARK: - Helpers

    func configure(invoice: Invoice) {
        let totalAmount = String(format: "%.2f", invoice.totalAmount)

        if !invoice.clientInfo.fullName.isEmpty {
            invoiceHeaderLabel.text = "#\(invoice.invoiceNumber): \(invoice.clientInfo.fullName)"
        } else {
            invoiceHeaderLabel.text = "#\(invoice.invoiceNumber)"
        }

        invoiceInfoLabel.text = invoice.dateCreated
        totalAmountLabel.text = "$\(totalAmount)"
    }
}
