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
             "quantity": item.quantity,
             "rate": item.rate]
        }

        let clientInfo: [String: Any] = ["fullName": invoice.clientInfo.fullName,
                                         "email": invoice.clientInfo.email,
                                         "phoneNumber": invoice.clientInfo.phoneNumber,
                                         "address1": invoice.clientInfo.address1,
                                         "address2": invoice.clientInfo.address2,
                                         "city": invoice.clientInfo.city,
                                         "state": invoice.clientInfo.state,
                                         "zipCode": invoice.clientInfo.zipCode]
        let customerInfo: [String: Any] = ["fullName": invoice.customerInfo.fullName,
                                         "email": invoice.customerInfo.email,
                                         "phoneNumber": invoice.customerInfo.phoneNumber,
                                         "address1": invoice.customerInfo.address1,
                                         "address2": invoice.customerInfo.address2,
                                         "city": invoice.customerInfo.city,
                                         "state": invoice.customerInfo.state,
                                         "zipCode": invoice.customerInfo.zipCode]

        let data: [String: Any] = ["uid": invoice.uid,
                                   "invoiceNumber": invoice.invoiceNumber,
                                   "dateCreated": invoice.dateCreated,
                                   "datePaid": invoice.datePaid,
                                   "paymentReceived": invoice.paymentReceived,
                                   "items": items,
                                   "totalAmount": invoice.totalAmount,
                                   "companyName": invoice.companyName,
                                   "clientInfo": clientInfo,
                                   "customerInfo": customerInfo,
                                   "ownerUid": invoice.ownerUid]

        COLLECTION_INVOICES.document(invoice.uid).setData(data, completion: completion)
    }

    static func fetchInvoices(forUser uid: String, completion: @escaping ([Invoice]) -> Void) {
        let query = COLLECTION_INVOICES.whereField("ownerUid", isEqualTo: uid)

        query.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }

            let invoices = documents.map { Invoice(dictionary: $0.data()) }

            completion(invoices)
        }
    }
}
