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

    /// Defines mutualy exclusive controller states
    enum ControllerState {
        case refreshing
        case idle
    }

    /// Database context manager dependency
    fileprivate let contextManager: ContextManager

    /// Network controller dependency
    fileprivate let networkController: NetworkController

    /// List of stored courses
    fileprivate var courses: Results<Course>?

    /// Realm notification token for course list changes
    private var token: NotificationToken?

    /// Current controller state (default: .idle), indicates whether controller
    /// is refreshing data or is idle
    private var controllerState = ControllerState.idle

    init(contextManager: ContextManager, networkController: NetworkController) {
        self.contextManager = contextManager
        self.networkController = networkController

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        animateRowsDeselect()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        configureView()
        refreshData()
    }

    /// Download new data
    func refreshData() {
        // Fixes refresh controller glitch which,
        // when the controller is loading, data are refreshed silentely
        guard controllerState != .refreshing else { return }

        controllerState = .refreshing

        networkController.loadCourseList {
            // Stop refresh control when download is comleted
            DispatchQueue.main.async { [weak self] in
                self?.controllerState = .idle
                self?.refreshControl?.endRefreshing()
            }
        }
    }

    /// Configure view related stuff
    private func configureView() {
        let refreshControl = UIRefreshControl()

        title = tr(.courses)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:
            UITableViewCell.identifier)
        tableView.addSubview(refreshControl)

        refreshControl.addTarget(self, action: #selector(refreshData),
                                 for: .valueChanged)

        self.refreshControl = refreshControl
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
            Logger.shared.error("\(error)")
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

            cell.selectionStyle = course.classificationAvailable
                ? .default
                : .none
            cell.accessoryType = course.classificationAvailable
                ? .disclosureIndicator
                : .none
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension CoursesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keychain = Keechain(service: .edux)

        guard
            let course = courses?[indexPath.row],
            let (student, _) = keychain.getAccount(),
            course.classificationAvailable == true else { return }

        let controller = CourseClassificationTableViewController(
            student: student,
            courseId: course.id,
            networkController: networkController,
            contextManager: contextManager
        )

        navigationController?.pushViewController(controller, animated: true)
    }
}
