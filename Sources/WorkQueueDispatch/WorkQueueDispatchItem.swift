//
//  WorkQueueDispatchItem.swift
//  
//
//  Created by Danny Sung on 12/20/2020.
//

import Foundation
import WorkQueue

public class WorkQueueDispatchItem: WorkQueueItem {
    public let workItem: DispatchWorkItem
    internal let state: WorkQueueItemState

    internal init(workItem: DispatchWorkItem, state: WorkQueueItemState) {
        self.workItem = workItem
        self.state = state
    }

    public var isExecuting: Bool {
        return self.state.isExecuting
    }

    public var isFinished: Bool {
        return self.state.isFinished
    }

    public func cancel() {
        self.workItem.cancel()
    }

    public var isCancelled: Bool {
        return self.workItem.isCancelled
    }
}

