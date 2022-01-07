//
//  User.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/26/21.
//

import Foundation

struct User {
    let uid: String
    let email: String
    let firstName: String
    let lastName: String
    let companyName: String
    let phoneNumber: String

    init(dictionary: [String: Any]) {
        uid = dictionary["uid"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        firstName = dictionary["firstname"] as? String ?? ""
        lastName = dictionary["lastName"] as? String ?? ""
        companyName = dictionary["companyName"] as? String ?? ""
        phoneNumber = dictionary["phoneNumber"] as? String ?? ""
    }
}
