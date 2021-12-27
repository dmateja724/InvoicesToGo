//
//  UIViewControllerExtension.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/27/21.
//

import UIKit

extension UIViewController {
    func showMessage(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
