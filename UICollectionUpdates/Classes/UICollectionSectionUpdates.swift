//
//  UICollectionSectionUpdates.swift
//  Pods-UICollectionUpdates_Example
//
//  Created by Aleksei Konshin on 02.07.2020.
//

import Foundation

/// List of updates for one section
public struct UICollectionSectionUpdates: Equatable {
    public var reloadIndexes = IndexSet()
    public var deleteIndexes = IndexSet()
    public var insertIndexes = IndexSet()

    public var isEmpty: Bool {
        return reloadIndexes.isEmpty
            && deleteIndexes.isEmpty
            && insertIndexes.isEmpty
    }

}

extension UICollectionSectionUpdates {

    /// Init from deletes/inserts diff
    ///
    /// - Parameter diff: Картеж дифа
    init(diff: (deletes: [Int], inserts: [Int])) {
        self.insertIndexes = IndexSet(diff.inserts)
        self.deleteIndexes = IndexSet(diff.deletes)
        reloadIndexes = IndexSet()
    }

}
