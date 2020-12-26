//
//  WorkQueueNIO.swift
//
//
//  Created by Danny Sung on 12/26/2020.
//

import Foundation
import NIO
import WorkQueue

public class WorkQueueNIO: WorkQueue {
    public let eventLoop: EventLoop

    required public init(eventLoop: EventLoop) {
        self.eventLoop = eventLoop
    }

    public func async(_ block: @escaping () -> Void) -> WorkQueueItem {
        let item: WorkQueueCancellableItem

        item = self.async(block)

        return item
    }

    public func async(_ block: @escaping () -> Void) -> WorkQueueCancellableItem {
        return self.asyncAfter(timeInterval: 0, execute: block)
    }
}

extension WorkQueueNIO: WorkQueueCancellable {

}

extension WorkQueueNIO: WorkQueueDeferrable {
    public func asyncAfter(timeInterval: TimeInterval, execute block: @escaping () -> Void) -> WorkQueueItem {
        let item: WorkQueueCancellableItem
        item = self.asyncAfter(timeInterval: timeInterval, execute: block)
        return item
    }

    public func asyncAfter(timeInterval: TimeInterval, execute block: @escaping () -> Void) -> WorkQueueCancellableItem {
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

        let workQueueItem = WorkQueueNIOCancellableItem(eventLoop: self.eventLoop, state: state, scheduled: scheduled)

        return workQueueItem
    }
}
