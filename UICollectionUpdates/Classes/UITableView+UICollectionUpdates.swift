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

}
