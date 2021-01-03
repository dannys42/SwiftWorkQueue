//
//  WorkQueueDispatch.swift
//  
//
//  Created by Danny Sung on 12/18/2020.
//

import Foundation
import WorkQueue

/// `WorkQueueDispatch` is a `WorkQueue` implementation that executes deferred code in a `DispatchQueue`
public class WorkQueueDispatch: WorkQueue {
    public let dispatchQueue: DispatchQueue

    /// Specifies this `WorkQueue` relies on the given `DispatchQueue`
    /// - Parameter queue: `DispatchQueue` to use
    required public init(queue: DispatchQueue) {
        self.dispatchQueue = queue
    }

    /// Creates a `WorkQueue` with a custom `DispatchQueue`
    /// - Parameter label: Label to use with the `DispatchQueue`
    public convenience init(label: String) {
        self.init(queue: DispatchQueue(label: label))
    }

    public func async(_ block: @escaping () -> Void) -> WorkQueueItem {

        let state = WorkQueueItemState()

        let workItem = DispatchWorkItem() {
            state.isExecuting = true
            block()
            state.isFinished = true
        }

        self.dispatchQueue.async(execute: workItem)

        return WorkQueueDispatchItem(workItem: workItem, state: state)
    }
}

