//
//  LoginView.swift
//  fit-checker
//
//  Created by Josef Dolezal on 07/02/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Wrapper for required login fields.
class LoginView: UIView {

    /// Layout constants
    struct Constants {
        /// Height of field separator
        static let separatorHeight: CGFloat = 1

        /// Field height ration to whole view
        static let fieldHeightMultiplier: CGFloat = 0.5

        /// Side margin of fields from wrapper
        static let fieldMargin: CGFloat = 17
    }

    /// Username text input
    let usernameTextField: UITextField = {
        let username = UITextField()
        username.autocapitalizationType = .none

        return username
    }()

    /// Password text input
    let passwordTextField: UITextField = {
        let password = UITextField()
        password.isSecureTextEntry = true
        password.autocapitalizationType = .none

        return password
    }()

    /// Fields visual separator
    let separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.CVUT.lightGray

        return separator
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        let subviews = [usernameTextField, passwordTextField, separatorView]

        subviews.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }

        let constraints = [
            usernameTextField.leadingAnchor.constraint(equalTo:
                leadingAnchor, constant: Constants.fieldMargin),
            usernameTextField.trailingAnchor.constraint(equalTo:
                trailingAnchor, constant: -Constants.fieldMargin),
            usernameTextField.topAnchor.constraint(equalTo: topAnchor),
            usernameTextField.heightAnchor.constraint(equalTo:
                heightAnchor, multiplier: Constants.fieldHeightMultiplier,
                              constant: -Constants.separatorHeight),
            separatorView.topAnchor.constraint(equalTo:
                usernameTextField.bottomAnchor),
            separatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorView.widthAnchor.constraint(equalTo: widthAnchor),
            separatorView.heightAnchor.constraint(equalToConstant:
                Constants.separatorHeight),
            passwordTextField.topAnchor.constraint(equalTo:
                separatorView.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo:
                usernameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo:
                usernameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo:
                heightAnchor, multiplier: Constants.fieldHeightMultiplier)
        ]

        constraints.forEach { $0.isActive = true }
    }

}
