//
//  Item.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/25/21.
//

import Foundation

struct Item {
    var name: String
    var quantity: Double
    var rate: Double

    init(dictionary: [String: Any]) {
        name = dictionary["name"] as? String ?? ""
        quantity = dictionary["quantity"] as? Double ?? 0.0
        rate = dictionary["rate"] as? Double ?? 0.0
    }
}
