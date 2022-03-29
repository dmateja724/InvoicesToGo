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
    var address1: String
    var address2: String
    var city: String
    var state: String
    var zipCode: String

    init(dictionary: [String: Any]) {
        fullName = dictionary["fullName"] as? String ?? ""
        phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        address1 = dictionary["address1"] as? String ?? ""
        address2 = dictionary["address2"] as? String ?? ""
        city = dictionary["city"] as? String ?? ""
        state = dictionary["state"] as? String ?? ""
        zipCode = dictionary["zipCode"] as? String ?? ""
    }
}
