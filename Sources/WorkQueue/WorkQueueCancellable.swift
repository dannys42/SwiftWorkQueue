//
//  WorkQueueCancellable.swift
//  
//
//  Created by Danny Sung on 12/20/2020.
//

import Foundation

public protocol WorkQueueCancellableItem: WorkQueueItem {
    func cancel()
    var isCancelled: Bool { get }
}

public protocol WorkQueueCancellable {
    @discardableResult
    func async(_ block: @escaping ()->Void) -> WorkQueueCancellableItem
}

extension WorkQueueCancellable {
    public func async(_ block: @escaping () -> Void) -> WorkQueueItem {
        let item: WorkQueueCancellableItem

        item = self.async(block)

        return item
    }
}

