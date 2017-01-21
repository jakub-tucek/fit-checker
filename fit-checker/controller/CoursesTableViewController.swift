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
    fileprivate let contextManager: ContextManager

    /// Network controller dependency
    fileprivate let networkController: NetworkController

    /// List of stored courses
    fileprivate var courses: Results<Course>?

    private var token: NotificationToken?

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

        loadData()
        configureView()
        refreshData()
    }

    /// Download new data
    func refreshData() {
        refreshControl?.beginRefreshing()

        networkController.loadCourseList {
            // Stop refresh control when download is comleted
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl?.endRefreshing()
            }
        }
    }

    /// Configure view related stuff
    private func configureView() {
        let refreshControl = UIRefreshControl()

        title = "Courses"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:
            UITableViewCell.identifier)
        tableView.addSubview(refreshControl)

        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData),
                                 for: .valueChanged)
    }

    /// Load stored data into view
    private func loadData() {
        do {
            let realm = try contextManager.createContext()

            courses = realm.objects(Course.self)
            token = courses?.addNotificationBlock { [weak self] _ in
                self?.tableView.reloadData()
            }
        } catch {
            print("\(error)")
        }
    }

    deinit {
        token?.stop()
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

        if let course = courses?[indexPath.row] {
            cell.textLabel?.text = course.name.uppercased()
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension CoursesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let course = courses?[indexPath.row] else {
            print("Daaamn man, user selected unselectable row!")
            return
        }

        let controller = CourseClassificationTableViewController(
            networkController: networkController,
            contextManager: contextManager,
            courseId: course.id
        )

        navigationController?.pushViewController(controller, animated: true)
    }
}
