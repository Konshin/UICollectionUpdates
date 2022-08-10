//
//  UICollectionSectionUpdates.swift
//  Pods-UICollectionUpdates_Example
//
//  Created by Aleksei Konshin on 02.07.2020.
//

import Foundation

/// List of updates for one section
public struct UICollectionSectionUpdates: Equatable {
    public var reloadIndexes: IndexSet = []
    public var deleteIndexes: IndexSet = []
    public var insertIndexes: IndexSet = []

    public var isEmpty: Bool {
        return reloadIndexes.isEmpty
            && deleteIndexes.isEmpty
            && insertIndexes.isEmpty
    }
    
    public init(reloadIndexes: IndexSet = [],
                deleteIndexes: IndexSet = [],
                insertIndexes: IndexSet = []) {
        self.reloadIndexes = reloadIndexes
        self.deleteIndexes = deleteIndexes
        self.insertIndexes = insertIndexes
    }

}

extension UICollectionSectionUpdates {

    /// Init from deletes/inserts diff
    ///
    /// - Parameter diff: Картеж дифа
    public init(diff: (deletes: [Int], inserts: [Int])) {
        self.insertIndexes = IndexSet(diff.inserts)
        self.deleteIndexes = IndexSet(diff.deletes)
        reloadIndexes = IndexSet()
    }

    /// Updates for sections, based on a diff
    /// - Parameter diff: Diff of models
    @available(iOS 13, *)
    public init<T>(diff: CollectionDifference<T>) {
        var insertions = IndexSet()
        var removals = IndexSet()
        
        diff.forEach { change in
            switch change {
            case .insert(let offset, _, _):
                insertions.insert(offset)
            case .remove(let offset, _, _):
                removals.insert(offset)
            }
        }
        self.insertIndexes = insertions
        self.deleteIndexes = removals
    }
  
}
