//
//  UICollectionUpdates.swift
//  Pods-UICollectionUpdates_Example
//
//  Created by Aleksei Konshin on 02.07.2020.
//

import Foundation

/// List of updates for collection
public struct UICollectionUpdates: Equatable {
    
    public var reloadIndexPaths: [IndexPath] = []
    public var deleteIndexPaths: [IndexPath] = []
    public var insertIndexPaths: [IndexPath] = []

    public var reloadSections: IndexSet = []
    public var deleteSections: IndexSet = []
    public var insertSections: IndexSet = []

    public var isEmpty: Bool {
        return reloadIndexPaths.isEmpty
        && deleteIndexPaths.isEmpty
        && insertIndexPaths.isEmpty
        && reloadSections.isEmpty
        && deleteSections.isEmpty
        && insertSections.isEmpty
    }
    
    public init(reloadIndexPaths: [IndexPath] = [],
                deleteIndexPaths: [IndexPath] = [],
                insertIndexPaths: [IndexPath] = [],
                reloadSections: IndexSet = [],
                deleteSections: IndexSet = [],
                insertSections: IndexSet = []) {
        self.reloadIndexPaths = reloadIndexPaths
        self.deleteIndexPaths = deleteIndexPaths
        self.insertIndexPaths = insertIndexPaths
        self.reloadSections = reloadSections
        self.deleteSections = deleteSections
        self.insertSections = insertSections
    }

    // MARK: getters

    public var quantitativeChangeOfSections: Int {
        return insertSections.count - deleteSections.count
    }

    /// Changes in sections. [SectionIndex: Change]
    public var quantitativeChangeOfItems: [Int: Int] {
        var result: [Int: Int] = [:]

        insertIndexPaths.forEach {
            result[$0.section, default: 0] += 1
        }
        deleteIndexPaths.forEach {
            result[$0.section, default: 0] -= 1
        }
        
        result = result.filter { $0.value != 0 }

        return result
    }

    // MARK: functions

    public func update(with updates: UICollectionSectionUpdates, section: Int) -> UICollectionUpdates {
        var result = self
        updates.insertIndexes.forEach { row in
            result.insertIndexPaths.append(IndexPath(row: row, section: section))
        }
        updates.deleteIndexes.forEach { row in
            result.deleteIndexPaths.append(IndexPath(row: row, section: section))
        }
        updates.reloadIndexes.forEach { row in
            result.reloadIndexPaths.append(IndexPath(row: row, section: section))
        }
        return result
    }

    public func merge(with updates: UICollectionUpdates) -> UICollectionUpdates {
        var result = self

        updates.insertSections.forEach { section in
            result.reloadSections.remove(section)
            result.insertSections.insert(section)
        }
        updates.deleteSections.forEach { section in
            result.reloadSections.remove(section)
            result.deleteSections.insert(section)
        }
        updates.reloadSections.forEach { section in
            guard !result.insertSections.contains(section), !result.deleteSections.contains(section) else {
                return
            }
            result.reloadSections.insert(section)
        }

        let allSectionUpdates = result.insertSections.union(result.deleteSections).union(result.reloadSections)
        updates.insertIndexPaths.forEach { ip in
            guard !allSectionUpdates.contains(ip.section) else { return }
            result.reloadIndexPaths.removeAll { $0 == ip }
            result.insertIndexPaths.append(ip)
        }
        updates.deleteIndexPaths.forEach { ip in
            guard !allSectionUpdates.contains(ip.section) else { return }
            result.reloadIndexPaths.removeAll { $0 == ip }
            result.deleteIndexPaths.append(ip)
        }
        updates.reloadIndexPaths.forEach { ip in
            guard !allSectionUpdates.contains(ip.section) else { return }
            result.reloadIndexPaths.append(ip)
        }

        return result
    }

    public func shiftIndexes(sectionsShift: Int) -> UICollectionUpdates {
        guard sectionsShift != 0 else { return self }

        var result = self

        let indexSetKeypaths: [WritableKeyPath<UICollectionUpdates, IndexSet>] = [\.insertSections, \.deleteSections, \.reloadSections]
        indexSetKeypaths.forEach { kp in
            let newValue = result[keyPath: kp].map { $0 + sectionsShift }
            result[keyPath: kp] = IndexSet(newValue)
        }

        let indexPathKeypaths: [WritableKeyPath<UICollectionUpdates, [IndexPath]>] = [\.insertIndexPaths, \.deleteIndexPaths, \.reloadIndexPaths]
        indexPathKeypaths.forEach { kp in
            let newValue = result[keyPath: kp].map { IndexPath(row: $0.row, section: $0.section + sectionsShift) }
            result[keyPath: kp] = newValue
        }

        return result
    }

}

extension UICollectionUpdates {
    
    /// Updates, based on a diff
    /// - Parameter diff: Diff of models
    /// - Parameter section: Section to update
    @available(iOS 13, *)
    public init<T>(diff: CollectionDifference<T>, section: Int) {
        func indexPath(from index: Int) -> IndexPath {
            return IndexPath(row: index, section: section)
        }
        
        insertIndexPaths = diff.insertions.map { change in
            switch change {
            case .insert(let offset, _, _), .remove(let offset, _, _):
                return indexPath(from: offset)
            }
        }
        deleteIndexPaths = diff.removals.map { change in
            switch change {
            case .insert(let offset, _, _), .remove(let offset, _, _):
                return indexPath(from: offset)
            }
        }
    }
    
    /// Updates, based on a diff
    /// - Parameter diff: Diff of models
    @available(iOS 13, *)
    public init<T>(diff: CollectionDifference<T>) {
        insertSections = diff.insertions.map { change in
            switch change {
            case .insert(let offset, _, _), .remove(let offset, _, _):
                return offset
            }
        }
        .reduce(into: []) { $0.insert($1) }
        deleteSections = diff.removals.map { change in
            switch change {
            case .insert(let offset, _, _), .remove(let offset, _, _):
                return offset
            }
        }
        .reduce(into: []) { $0.insert($1) }
    }

    public init(sectionUpdates: UICollectionSectionUpdates, section: Int) {
        let convert: (Int) -> IndexPath = { (index) -> IndexPath in
            return IndexPath(row: index, section: section)
        }
        reloadIndexPaths = sectionUpdates.reloadIndexes.map(convert)
        insertIndexPaths = sectionUpdates.insertIndexes.map(convert)
        deleteIndexPaths = sectionUpdates.deleteIndexes.map(convert)
    }

}
