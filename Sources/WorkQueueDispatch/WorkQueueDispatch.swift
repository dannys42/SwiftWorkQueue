//
//  WorkQueueDispatch.swift
//  
//
//  Created by Danny Sung on 12/18/2020.
//

import Foundation
import WorkQueue

public class WorkQueueDispatch: WorkQueue {
    public let dispatchQueue: DispatchQueue

    required public init(queue: DispatchQueue) {
        self.dispatchQueue = queue
    }

    convenience init(label: String) {
        self.init(queue: DispatchQueue(label: label))
    }
}

public class WorkQueueDispatchCancellableItem: WorkQueueDispatchItem, WorkQueueCancellableItem {
    public func cancel() {
        self.workItem.cancel()
    }

    public var isCancelled: Bool {
        return self.workItem.isCancelled
    }
}

extension WorkQueueDispatch: WorkQueueCancellable {
    public func async(_ block: @escaping () -> Void) -> WorkQueueCancellableItem {

        let state = WorkQueueDispatchItemState()

        let workItem = DispatchWorkItem() {
            state.isExecuting = true
            block()
            state.isFinished = true
        }

        self.dispatchQueue.async(execute: workItem)

        return WorkQueueDispatchCancellableItem(workItem: workItem, state: state)
    }
}

