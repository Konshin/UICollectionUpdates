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

        if !validateConsistency(updates: updates) {
            throw UICollectionUpdateError.inconsistency
        }

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
    
    // MARK: - private

    private func validateConsistency(updates: UICollectionUpdates) -> Bool {
        let numberOfSections = self.numberOfSections
        let numberOfSectionsInDatasource = self.dataSource?.numberOfSections?(in: self) ?? 0
        let quantitativeChangeOfSections = updates.quantitativeChangeOfSections

        if (numberOfSectionsInDatasource - numberOfSections) != quantitativeChangeOfSections {
            return false
        }

        let quantitativeChangesOfItems = updates.quantitativeChangeOfItems
        let quantitativeChangesByDatasource = quantitativeChangeOfItems(updates: updates)
        if quantitativeChangesOfItems != quantitativeChangesByDatasource {
            return false
        }

        return true
    }

    private func quantitativeChangeOfItems(updates: UICollectionUpdates) -> [Int: Int] {
        var result = [Int: Int]()

        var dataSourceSection = -1
        for section in 0..<numberOfSections {
            dataSourceSection += 1
            if updates.insertSections.contains(dataSourceSection) {
                dataSourceSection += 1
                continue
            }
            if updates.deleteSections.contains(section) {
                dataSourceSection -= 1
                continue
            }
            if updates.reloadSections.contains(section) {
                continue
            }

            let numberOfRows = self.numberOfItems(inSection: section)
            let numberOfItemsInDatasource = self.dataSource?.collectionView(self, numberOfItemsInSection: dataSourceSection) ?? 0
            let change = numberOfItemsInDatasource - numberOfRows
            if change != 0 {
                result[section] = change
            }
        }

        return result
    }

}
