//
//  WorkQueueNIOItem.swift
//
//
//  Created by Danny Sung on 12/22/2020.
//

import Foundation
import NIO
import WorkQueue

public class WorkQueueNIOItem: WorkQueueItem {
    public let eventLoop: EventLoop
    public typealias ScheduledType = Scheduled<()>
    internal let scheduled: ScheduledType
    internal let state: WorkQueueItemState
    fileprivate var didCancel = false

    public init(eventLoop: EventLoop, state: WorkQueueItemState, scheduled: ScheduledType) {
        self.eventLoop = eventLoop
        self.state = state
        self.scheduled = scheduled
    }

    public var isExecuting: Bool {
        return self.state.isExecuting
    }

    public var isFinished: Bool {
        return self.state.isFinished
    }
}

public class WorkQueueNIOCancellableItem: WorkQueueNIOItem, WorkQueueCancellableItem {

    public func cancel() {
        self.didCancel = true
        self.scheduled.cancel()
    }

    public var isCancelled: Bool {
        if self.state.isFinished || self.state.isExecuting {
            return false
        }
        if self.didCancel {
            return true
        }
        return false
    }
}

