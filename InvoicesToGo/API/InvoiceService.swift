//
//  InvoiceService.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/30/21.
//

import FirebaseFirestore

enum InvoiceService {
    static func saveInvoice(invoice: Invoice, completion: @escaping (Error?) -> Void) {
        let items: [[String: Any]] = invoice.items.map { item in
            ["name": item.name,
             "quantity": item.quatity,
             "rate": item.rate]
        }

        let clientInfo: [String: Any] = ["fullName": invoice.clientInfo.fullName,
                                         "email": invoice.clientInfo.email,
                                         "phoneNumber": invoice.clientInfo.phoneNumber]

        let data: [String: Any] = ["uid": invoice.uid,
                                   "invoiceNumber": invoice.invoiceNumber,
                                   "dateCreated": invoice.dateCreated,
                                   "datePaid": invoice.datePaid,
                                   "paymentReceived": invoice.paymentReceived,
                                   "items": items,
                                   "totalAmount": invoice.totalAmount,
                                   "companyName": invoice.companyName,
                                   "clientInfo": clientInfo,
                                   "ownerUid": invoice.ownerUid]

        COLLECTION_INVOICES.document(invoice.uid).setData(data, completion: completion)
    }
}
