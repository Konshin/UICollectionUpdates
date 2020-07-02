//
//  UITableView+UICollectionUpdates.swift
//  wheel-size-ios
//
//  Created by Aleksei Konshin on 08.04.2020.
//  Copyright © 2020 Wheel-Size. All rights reserved.
//

import UIKit

extension UITableView: UICollection {

    /// Safe reload with animation
    /// throws: In case of error, the tableview will be reloaded by reloadData()
    ///
    /// - Parameter updates: List of updates
    /// - Parameter animation: Kind of animation
    public func perform(updates: UICollectionUpdates, with animation: RowAnimation, completion: ((Bool) -> Void)? = nil) throws {
        guard !updates.isEmpty else { return }

        if !validateConsistency(updates: updates) {
            throw UICollectionUpdateError.inconsistency
        }

        beginUpdates()

        deleteSections(updates.deleteSections, with: animation)
        insertSections(updates.insertSections, with: animation)
        reloadSections(updates.reloadSections, with: animation)

        deleteRows(at: updates.deleteIndexPaths, with: animation)
        insertRows(at: updates.insertIndexPaths, with: animation)
        reloadRows(at: updates.reloadIndexPaths, with: animation)

        endUpdates()
        completion?(true)
    }
    
    // MARK: - private

    private func validateConsistency(updates: UICollectionUpdates) -> Bool {
        let numberOfSections = self.numberOfSections
        let numberOfSectionsInDatasource = self.dataSource?.numberOfSections?(in: self) ?? 1
        let quantitativeChangeOfSections = updates.quantitativeChangeOfSections

        if (numberOfSectionsInDatasource - numberOfSections) != quantitativeChangeOfSections {
            return false
        }

        let quantitativeChangesOfItems = updates.quantitativeChangeOfItems
        for (section, change) in quantitativeChangesOfItems {
            let numberOfRows = self.numberOfRows(inSection: section)
            let numberOfItemsInDatasource = self.dataSource?.tableView(self, numberOfRowsInSection: section) ?? 0
            if (numberOfItemsInDatasource - numberOfRows) != change {
                return false
            }
        }

        return true
    }

}
