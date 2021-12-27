//
//  AuthService.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/27/21.
//

import Firebase
import UIKit

enum AuthService {
    static func logUserIn(email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
}
