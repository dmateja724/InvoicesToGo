//
//  PDFPreviewViewModel.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 1/3/22.
//

import Foundation

class PDFPreviewViewModel {
    var invoice: Invoice
    var user: User
    var pageCount: Int = 1
    var totalPageCount: Int = 0

    init(user: User, invoice: Invoice) {
        self.user = user
        self.invoice = invoice
        totalPageCount = invoice.items.count / 20
    }
}
