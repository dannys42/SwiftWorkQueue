//
//  WorkQueueRunLoop.swift
//  
//
//  Created by Danny Sung on 12/18/2020.
//

import Foundation
import WorkQueue

/// `WorkQueueRunLoop` is a `WorkQueue` implementation that executes deferred code in a `RunLoop`
public class WorkQueueRunLoop: WorkQueue {
    public let runLoop: RunLoop
    public let mode: RunLoop.Mode

    /// Specifies this `WorkQueue` relies on the given `RunLoop`
    /// - Parameter operationQueue: `OperationQueue` to use
    /// - Parameter runLoop: `RunLoop` to use
    /// - Parameter mode: `RunLoop.Mode` to use (default: .default)
    required public init(runLoop: RunLoop, mode: RunLoop.Mode = .default) {
        self.runLoop = runLoop
        self.mode = mode
    }

    public func async(_ block: @escaping () -> Void) -> WorkQueueItem {
        return self.asyncAfter(timeInterval: 0, execute: block)
    }
}

extension WorkQueueRunLoop: WorkQueueDeferrable {
    public func asyncAfter(timeInterval: TimeInterval, execute block: @escaping () -> Void) -> WorkQueueItem {
        let state = WorkQueueItemState()
        let timer = Timer(timeInterval: timeInterval, repeats: false) { (_) in
            state.isExecuting = true
            block()
            state.isFinished = true
            state.isExecuting = false
        }
        let workQueueItem = WorkQueueRunLoopItem(runLoop: self.runLoop, state: state, timer: timer)
        self.runLoop.add(timer, forMode: self.mode)
        return workQueueItem
    }
}
