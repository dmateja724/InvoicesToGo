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
    
    init(user: User, invoice: Invoice) {
        self.user = user
        self.invoice = invoice
    }
}
