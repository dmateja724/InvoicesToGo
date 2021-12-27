//
//  AuthService.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/27/21.
//

import Firebase
import UIKit

struct AuthCredentials {
    let firstName: String
    let lastName: String
    let companyName: String
    let email: String
    let password: String
}

enum AuthService {
    static func logUserIn(email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register user \(error.localizedDescription)")
                return
            }

            guard let uid = result?.user.uid else { return }
            let data: [String: Any] = ["uid": uid,
                                       "firstname": credentials.firstName,
                                       "lastName": credentials.lastName,
                                       "email": credentials.email,
                                       "companyName": credentials.companyName]

            COLLECTION_USERS.document(uid).setData(data, completion: completion)
        }
    }
}
