//
//  ItemCell.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/22/21.
//

import UIKit

class ItemCell: UITableViewCell {
    // MARK: - Properties

    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var qtyAmountLabel: UILabel!
    @IBOutlet var totalCostLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Helpers
    
    func configure(item: Item) {
        let rate = String(format: "%.2f", item.rate)
        let totalCost = String(format: "%.2f", Double(item.quatity) * item.rate)
        
        itemNameLabel.text = item.name
        qtyAmountLabel.text = "\(item.quatity) x $\(rate)"
        totalCostLabel.text = "$\(totalCost)"
    }
}
