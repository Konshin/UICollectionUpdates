//
//  UICollection.swift
//  wheel-size-ios
//
//  Created by Aleksei Konshin on 08.04.2020.
//  Copyright © 2020 Wheel-Size. All rights reserved.
//

import UIKit

enum UICollectionUpdateError: Error {
    case inconsistency
}

public protocol UICollection {

    associatedtype RowAnimation

    func perform(updates: UICollectionUpdates, with animation: RowAnimation, completion: ((Bool) -> Void)?) throws

    func reloadData()

}

extension UICollection {

    public func perform(updates: UICollectionUpdates, with animation: RowAnimation, completion: ((Bool) -> Void)? = nil) throws {
        try perform(updates: updates, with: animation, completion: completion)
    }

    public func performOrReload(updates: UICollectionUpdates, with animation: RowAnimation, completion: ((Bool) -> Void)? = nil) {
        do {
            try perform(updates: updates, with: animation, completion: completion)
        } catch {
            reloadData()
            completion?(false)
        }
    }

}

extension UICollection where RowAnimation == Void {

    public func perform(updates: UICollectionUpdates) throws {
        performOrReload(updates: updates, with: Void())
    }

    public func performOrReload(updates: UICollectionUpdates) {
        performOrReload(updates: updates, with: Void())
    }

}
