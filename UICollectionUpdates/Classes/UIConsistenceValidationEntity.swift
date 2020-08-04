//
//  UIConsistenceValidationEntity.swift
//  Pods-UICollectionUpdates_Example
//
//  Created by Aleksei Konshin on 04.08.2020.
//

import Foundation

/// An entity that can be chacked for consistance with datasource
protocol UIConsistenceValidationEntity {
    
    var numberOfSections: Int { get }
    
    func numberOfElements(section: Int) -> Int
    
    var numberOfSectionsFromDataSource: Int? { get }
    
    func numberOfElementsInSectionFromDataSource(section: Int) -> Int?
    
}

extension UIConsistenceValidationEntity {
    
    func validateConsistency(updates: UICollectionUpdates) -> Bool {
        let numberOfSections = self.numberOfSections
        let numberOfSectionsInDatasource = self.numberOfSectionsFromDataSource ?? 0
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

            let numberOfRows = self.numberOfElements(section: section)
            let numberOfItemsInDatasource = self.numberOfElementsInSectionFromDataSource(section: dataSourceSection) ?? 0
            let change = numberOfItemsInDatasource - numberOfRows
            if change != 0 {
                result[section] = change
            }
        }

        return result
    }
    
}

// MARK: - UICollectionView
extension UICollectionView: UIConsistenceValidationEntity {
    
    func numberOfElements(section: Int) -> Int {
        return numberOfItems(inSection: section)
    }
    
    var numberOfSectionsFromDataSource: Int? {
        return dataSource?.numberOfSections?(in: self)
    }
    
    func numberOfElementsInSectionFromDataSource(section: Int) -> Int? {
        return dataSource?.collectionView(self, numberOfItemsInSection: section)
    }
    
}

// MARK: - UITableView
extension UITableView: UIConsistenceValidationEntity {
    
    func numberOfElements(section: Int) -> Int {
        return numberOfRows(inSection: section)
    }
    
    var numberOfSectionsFromDataSource: Int? {
        return dataSource?.numberOfSections?(in: self)
    }
    
    func numberOfElementsInSectionFromDataSource(section: Int) -> Int? {
        return dataSource?.tableView(self, numberOfRowsInSection: section)
    }
    
}
