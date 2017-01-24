//
//  UITableViewController+Deselect.swift
//  fit-checker
//
//  Created by Josef Dolezal on 24/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewController {
    func animateRowsDeselect() {
        let selectedIndexPaths = tableView.indexPathsForSelectedRows ?? []

        /// Deselect rows without animation if coordinator does not
        /// exists
        guard let coordinator = transitionCoordinator else {
            selectedIndexPaths.forEach({ indexPath in
                tableView.deselectRow(at: indexPath, animated: true)
            })

            return
        }

        /// Deselect rows as user moves view on top of tableview
        coordinator.animateAlongsideTransition(in: parent?.view, animation: { context in
            selectedIndexPaths.forEach({ [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath,
                                            animated: context.isAnimated)
            })
        }, completion: { [weak self] context in
            guard context.isCancelled else { return }

            selectedIndexPaths.forEach({ indexPath in
                self?.tableView.selectRow(at: indexPath,
                                          animated: context.isAnimated,
                                          scrollPosition: .none)
            })
        })
    }
}
