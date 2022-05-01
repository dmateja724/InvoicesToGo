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
    var datePaid: String
    var paymentReceived: Bool
    var items: [Item] = .init()
    var totalAmount: Double
    var clientInfo: Client
    var customerInfo: Client

    init(dictionary: [String: Any]) {
        uid = dictionary["uid"] as? String ?? ""
        invoiceNumber = (dictionary["invoiceNumber"] as? Int ?? 00)
        dateCreated = dictionary["dateCreated"] as? String ?? ""
        companyName = dictionary["companyName"] as? String ?? ""
        ownerUid = dictionary["ownerUid"] as? String ?? ""
        datePaid = dictionary["datePaid"] as? String ?? ""
        paymentReceived = dictionary["paymentReceived"] as? Bool ?? false

        setItems: if let dictItems = dictionary["items"] as? [[String: Any]] {
            if dictItems.isEmpty {
                break setItems
            } else {
                for item in dictionary["items"] as? [[String: Any]] ?? [[:]] {
                    items.append(Item(dictionary: item))
                }
            }
        }

        totalAmount = dictionary["totalAmount"] as? Double ?? 0.0
        clientInfo = Client(dictionary: dictionary["clientInfo"] as? [String: Any] ?? [:])
        customerInfo = Client(dictionary: dictionary["customerInfo"] as? [String: Any] ?? [:])
    }
}
