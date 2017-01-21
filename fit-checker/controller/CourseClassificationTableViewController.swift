//
//  CourseClassificationTableViewController.swift
//  fit-checker
//
//  Created by Josef Dolezal on 21/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import RealmSwift

/// Displays current classification for specific course.
class CourseClassificationTableViewController: UITableViewController {

    /// Network requests controller
    private let networkController: NetworkController

    /// Database context manager
    private let contextManager: ContextManager

    /// Selected course identifier
    private let courseId: String

    /// Current student username
    private let student: String

    /// Classification tables
    fileprivate var tables: Results<CourseTable>?

    /// Realm changes notification token
    private var token: NotificationToken?

    init(student: String, courseId: String,
         networkController: NetworkController, contextManager: ContextManager) {

        self.courseId = courseId
        self.student = student
        self.networkController = networkController
        self.contextManager = contextManager

        super.init(style: .grouped)
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

    /// Configure view and setup subviews
    private func configureView() {
        title = courseId

        tableView.allowsSelection = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:
            UITableViewCell.identifier)
    }

    /// Load stored data
    private func loadData() {
        do {
            let realm = try contextManager.createContext()

            tables = realm.objects(CourseTable.self)
                .filter("courseId = %@", courseId)
            token = tables?.addNotificationBlock({ _ in
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            })
        } catch {
            print("Could not create realm instance: \(error)")
        }
    }

    /// Download new data
    private func refreshData() {
        networkController.loadCourseClassification(courseId: courseId,
                                                   student: student)
    }

    deinit {
        token?.stop()
    }
}


// MARK: - UITableViewDataSource
extension CourseClassificationTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tables?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tables?[section].classification.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            UITableViewCell.identifier, for: indexPath)

        if let classification = tables?[indexPath.section]
            .classification[indexPath.row] {

            cell.textLabel?.text = "\(classification.name) - \(classification.score)"
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tables?[section].name
    }
}
