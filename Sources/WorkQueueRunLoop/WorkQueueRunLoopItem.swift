//
//  WorkQueueDispatchItem.swift
//  
//
//  Created by Danny Sung on 12/22/2020.
//

import Foundation
import WorkQueue

public class WorkQueueRunLoopItem: WorkQueueItem {
    public let runLoop: RunLoop
    internal let timer: Timer
    internal let state: WorkQueueItemState

    public init(runLoop: RunLoop, state: WorkQueueItemState, timer: Timer) {
        self.runLoop = runLoop
        self.state = state
        self.timer = timer
    }

    public var isExecuting: Bool {
        return self.state.isExecuting
    }

    public var isFinished: Bool {
        return self.state.isFinished
    }
}

public class WorkQueueRunLoopCancellableItem: WorkQueueRunLoopItem, WorkQueueCancellableItem {

    public func cancel() {
        self.timer.invalidate()
    }

    public var isCancelled: Bool {
        if self.state.isFinished || self.state.isExecuting {
            return false
        }

        return self.timer.isValid
    }


}

