//
//  Invoice.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/25/21.
//

import Foundation

struct Invoice {
    var invoiceNumber: Int
    var date: String
    var items = [Item]()
    var totalAmount = 0.0
    var companyName: String
}
