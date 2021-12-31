//
//  Invoice.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/25/21.
//

import Foundation

struct Invoice {
    var uid: String
    var invoiceNumber: Int
    var dateCreated: String
    var companyName: String
    var ownerUid: String
    var datePaid: String = ""
    var paymentReceived: Bool = false
    var items: [Item] = [Item]()
    var totalAmount: Double = 0.0
    var clientInfo: Client = Client(fullName: "", phoneNumber: "", email: "")
}
