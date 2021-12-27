//
//  UserService.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/27/21.
//

import Firebase

enum UserService {
    static func fetchUser(withUid uid: String, completion: @escaping (User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, _ in

            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
}
