//
//  CoursesTableViewController.swift
//  fit-checker
//
//  Created by Josef Dolezal on 18/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import RealmSwift

/// Courses list controller.
class CoursesTableViewController: UITableViewController {

    /// Database context manager dependency
    private let contextManager: ContextManager

    /// Network controller dependency
    private let networkController: NetworkController

    /// List of stored courses
    fileprivate var courses: Results<Course>?

    init(contextManager: ContextManager, networkController: NetworkController) {
        self.contextManager = contextManager
        self.networkController = networkController

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        fetchData()
    }

    /// Configure view related stuff
    private func configureView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:
            UITableViewCell.identifier)
    }

    /// Load stored data and load new
    private func fetchData() {
        do {
            let realm = try contextManager.createContext()

            courses = realm.objects(Course.self)
        } catch {
            print("\(error)")
        }
    }
}

// MARK: - UITableViewDataSource
extension CoursesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            UITableViewCell.identifier, for: indexPath)

        if let courses = courses {
            cell.textLabel?.text = courses[indexPath.row].name.uppercased()
        }

        return cell
    }
}