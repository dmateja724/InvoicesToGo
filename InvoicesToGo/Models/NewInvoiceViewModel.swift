//
//  NewInvoiceViewModel.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/21/21.
//

import Foundation

struct Item {
    var name: String
    var quatity: Int
    var rate: Double
}

struct NewInvoiceViewModel {
    var invoiceNumber: Int
    var date: String
    var items: [Item]
}
