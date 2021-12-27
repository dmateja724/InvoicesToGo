//
//  Invoices.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/25/21.
//

import Foundation

struct InvoicesViewModel {
    let user: User
    var invoices = [Invoice]()

    init(user: User) {
        self.user = user
    }
}
