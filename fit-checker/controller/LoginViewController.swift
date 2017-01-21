//
//  LoginViewController.swift
//  fit-checker
//
//  Created by Josef Dolezal on 13/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// User login view controller.
class LoginViewController: UIViewController {

    //MARK: UI

    /// Holds UI layout constants
    struct Layout {
        static let spacing: CGFloat = 15
        static let inputWidth: CGFloat = 200
        static let buttonWidth: CGFloat = 80
        static let fieldHeight: CGFloat = 22
    }

    /// Username input field
    private let usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = tr(.username)

        return field
    }()

    /// Password input field
    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = tr(.password)

        return field
    }()

    /// Login action button
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(tr(.login), for: .normal)

        return button
    }()

    //MARK: Properties

    /// Injected network controller
    private let networkController: NetworkController

    //MARK: Initialization

    init(networkController: NetworkController) {
        self.networkController = networkController

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Controller logic

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        configureView()
    }

    /// Handles user login action
    public func login() {
        guard
            let username = usernameField.text,
            let password = passwordField.text,
            username.characters.count > 0,
            password.characters.count > 0 else { return }

        let promise = networkController.authorizeUser(with: username,
                                                      password: password)

        promise.success = {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .FCLoginStateChanged,
                                                object: nil)
            }
        }
    }

    /// Configures all subviews layouts
    private func configureView() {
        let views = [usernameField, passwordField, loginButton]

        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        let constraints = [
            usernameField.topAnchor.constraint(equalTo:
                view.topAnchor, constant: Layout.spacing * 5.0),
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.widthAnchor.constraint(equalToConstant:
                Layout.inputWidth),
            usernameField.heightAnchor.constraint(equalToConstant:
                Layout.fieldHeight),
            passwordField.topAnchor.constraint(equalTo:
                usernameField.bottomAnchor, constant: Layout.spacing),
            passwordField.centerXAnchor.constraint(equalTo:
                usernameField.centerXAnchor),
            passwordField.widthAnchor.constraint(equalTo:
                usernameField.widthAnchor),
            passwordField.heightAnchor.constraint(equalTo:
                usernameField.heightAnchor),
            loginButton.topAnchor.constraint(equalTo:
                passwordField.bottomAnchor, constant: Layout.spacing),
            loginButton.centerXAnchor.constraint(equalTo:
                passwordField.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant:
                Layout.buttonWidth),
            loginButton.heightAnchor.constraint(equalTo:
                passwordField.heightAnchor)
        ]

        constraints.forEach { $0.isActive = true }
        
        loginButton.addTarget(self, action: #selector(login),
                              for: .touchUpInside)
    }
}
