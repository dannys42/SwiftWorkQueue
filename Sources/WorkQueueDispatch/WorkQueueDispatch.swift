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

