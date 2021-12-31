//
//  Client.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/30/21.
//

import Foundation

struct Client {
    var fullName: String
    var phoneNumber: String
    var email: String

    init(dictionary: [String: Any]) {
        fullName = dictionary["fullName"] as? String ?? ""
        phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
    }
}
