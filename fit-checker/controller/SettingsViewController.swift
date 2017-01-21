//
//  SettingsViewController.swift
//  fit-checker
//
//  Created by Josef Dolezal on 20/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// User settings view controller.
class SettingsViewController: UIViewController {

    /// Shared operations queue
    private let operationQueue = OperationQueue()

    /// Database context manager
    private let contextManager: ContextManager

    //MARK: - Initializers

    init(contextManager: ContextManager) {
        self.contextManager = contextManager

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Logic

    /// Logout button
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(tr(.logout), for: .normal)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    /// Run logout procedure
    func logout() {
        let logoutOperation = LogoutOperation(contextManager: contextManager)

        operationQueue.addOperation(logoutOperation)
    }

    //MARK: - Private methods

    /// Configure view and subviews
    private func configureView() {
        view.addSubview(logoutButton)
        view.backgroundColor = .white

        logoutButton.addTarget(self, action: #selector(logout),
                               for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 150),
            logoutButton.heightAnchor.constraint(equalToConstant: 22)
        ]

        constraints.forEach({ $0.isActive = true })
    }
}
