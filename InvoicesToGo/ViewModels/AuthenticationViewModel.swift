//
//  AuthenticationViewModel.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 12/27/21.
//

import UIKit

protocol FormViewModel {
    func updateForm()
}

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?

    var formIsValid: Bool {
        email?.isEmpty == false && password?.isEmpty == false
    }

    var buttonBackgroundColor: UIColor {
        formIsValid ? .link : .link.withAlphaComponent(0.1)
    }

    var buttonTitleColor: UIColor {
        formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}

struct SignUpViewModel: AuthenticationViewModel {
    var firstName: String?
    var lastName: String?
    var companyName: String?
    var email: String?
    var password: String?
    var phoneNumber: String?

    var formIsValid: Bool {
        firstName?.isEmpty == false && lastName?.isEmpty == false && companyName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
    }

    var buttonBackgroundColor: UIColor {
        formIsValid ? .link : .link.withAlphaComponent(0.1)
    }

    var buttonTitleColor: UIColor {
        formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}

struct ResetPasswordViewModel: AuthenticationViewModel {
    var email: String?

    var formIsValid: Bool {
        email?.isEmpty == false
    }

    var buttonBackgroundColor: UIColor {
        formIsValid ? .link : .link.withAlphaComponent(0.1)
    }

    var buttonTitleColor: UIColor {
        formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}
