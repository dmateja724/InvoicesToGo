//
//  InvoiceCell.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/23/21.
//

import UIKit

class InvoiceCell: UITableViewCell {
    // MARK: - Properties

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func printInvoicePressed(_ sender: UIButton) {
        print("print invoice here")
    }
    
    func configure() {
        
    }
}
