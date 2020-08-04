//
//  UICollectionView+UICollectionUpdates.swift
//  wheel-size-ios
//
//  Created by Aleksei Konshin on 08.04.2020.
//  Copyright © 2020 Wheel-Size. All rights reserved.
//

import UIKit

extension UICollectionView: UICollection {

    public typealias RowAnimation = Void

    /// Safe reload with animation
    /// throws: In case of error, the tableview will be reloaded by reloadData()
    ///
    /// - Parameter updates: List of updates
    /// - Parameter animation: Kind of animation
    public func perform(updates: UICollectionUpdates, with animation: RowAnimation, completion: ((Bool) -> Void)? = nil) throws {
        guard !updates.isEmpty else {
            completion?(true)
            return
        }

        try validateConsistency(updates: updates)

        performBatchUpdates({
            deleteSections(updates.deleteSections)
            insertSections(updates.insertSections)
            reloadSections(updates.reloadSections)

            deleteItems(at: updates.deleteIndexPaths)
            insertItems(at: updates.insertIndexPaths)
            reloadItems(at: updates.reloadIndexPaths)
        },
                            completion: completion)
    }

}
