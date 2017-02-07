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
        /// Top offset of logo
        static let logoOffset: CGFloat = 65

        /// Top offset of login view from logo
        static let loginOffset: CGFloat = 70

        /// Width of fields view wrapper
        static let loginViewWidth: CGFloat = 280

        /// Height of fields view wrapper
        static let loginViewHeight: CGFloat = 80

        /// Spacing between login view and button
        static let viewsSpacing: CGFloat = 12

        /// Button x axis offset from login view
        static let buttonOffset: CGFloat = 20

        /// Login button height
        static let buttonHeight: CGFloat = 33

    }

    /// View with username and password fields
    private let loginView = LoginView()

    /// Login action button
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(tr(.login), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.CVUT.activeButton
        button.addTarget(self, action: #selector(login), for: .touchUpInside)

        return button
    }()

    private let logoImageView = UIImageView(image: #imageLiteral(resourceName: "cvut-logo"))

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
            let username = loginView.usernameTextField.text,
            let password = loginView.passwordTextField.text,
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
        let views = [logoImageView, loginView, loginButton]

        view.backgroundColor = UIColor.CVUT.blue
        loginView.backgroundColor = .white
        loginView.layer.masksToBounds = true
        loginView.layer.cornerRadius = 3
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 3

        loginView.usernameTextField.placeholder = tr(.username)
        loginView.passwordTextField.placeholder = tr(.password)

        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        let constraints = [
            logoImageView.topAnchor.constraint(equalTo:
                view.topAnchor, constant: Layout.logoOffset),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginView.topAnchor.constraint(equalTo:
                logoImageView.bottomAnchor, constant: Layout.loginOffset),
            loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginView.widthAnchor.constraint(equalToConstant:
                Layout.loginViewWidth),
            loginView.heightAnchor.constraint(equalToConstant:
                Layout.loginViewHeight),
            loginButton.topAnchor.constraint(equalTo:
                loginView.bottomAnchor, constant: Layout.viewsSpacing),
            loginButton.leadingAnchor.constraint(equalTo:
                loginView.leadingAnchor, constant: Layout.buttonOffset),
            loginButton.trailingAnchor.constraint(equalTo:
                loginView.trailingAnchor, constant: -Layout.buttonOffset),
            loginButton.heightAnchor.constraint(equalToConstant:
                Layout.buttonHeight)
        ]

        constraints.forEach{ $0.isActive = true }
    }
}
