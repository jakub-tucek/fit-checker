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

    init(networkController: NetworkController, contextManager: ContextManager,
         courseId: String) {

        self.networkController = networkController
        self.contextManager = contextManager
        self.courseId = courseId

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
    }

    /// Load stored data
    private func loadData() {

    }

    /// Download new data
    private func refreshData() {

    }
}
