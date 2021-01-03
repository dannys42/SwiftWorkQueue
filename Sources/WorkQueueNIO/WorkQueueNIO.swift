//
//  WorkQueueNIO.swift
//
//
//  Created by Danny Sung on 12/26/2020.
//

import Foundation
import NIO
import WorkQueue

/// `WorkQueueNIO` is a `WorkQueue` implementation that executes deferred code in a NIO `EventLoop`
public class WorkQueueNIO: WorkQueue {
    public let eventLoop: EventLoop

    /// Initialize with a specified NIO `EventLoop`
    /// - Parameter eventLoop: `EventLoop` to use
    required public init(eventLoop: EventLoop) {
        self.eventLoop = eventLoop
    }

    public func async(_ block: @escaping () -> Void) -> WorkQueueItem {
        return self.asyncAfter(timeInterval: 0, execute: block)
    }
}

extension WorkQueueNIO: WorkQueueDeferrable {
    public func asyncAfter(timeInterval: TimeInterval, execute block: @escaping () -> Void) -> WorkQueueItem {
        let state = WorkQueueItemState()

        let timeAmount: TimeAmount
        if timeInterval <= 0 {
            timeAmount = .zero
        } else if timeInterval < 1_000 {
            timeAmount = TimeAmount.milliseconds(Int64(timeInterval * 1_000))
        } else {
            timeAmount = TimeAmount.seconds(Int64(timeInterval))
        }

        let scheduled = self.eventLoop.scheduleTask(in: timeAmount) {
            state.isExecuting = true
            block()
            state.isFinished = true
            state.isExecuting = false
        }

        let workQueueItem = WorkQueueNIOItem(eventLoop: self.eventLoop, state: state, scheduled: scheduled)

        return workQueueItem
    }
}
