//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport


/// User login view controller.
class LoginViewController: UIViewController {

    struct Layout {
        static let spacing: CGFloat = 15
        static let inputWidth: CGFloat = 200
        static let buttonWidth: CGFloat = 80
        static let fieldHeight: CGFloat = 22
    }

    let usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username"

        return field
    }()

    let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"

        return field
    }()

    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        configureView()
    }

    public func login() {

    }

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

        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
}


let controller = LoginViewController()

PlaygroundPage.current.liveView = controller
