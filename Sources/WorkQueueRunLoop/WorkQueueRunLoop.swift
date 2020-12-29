//
//  WorkQueueRunLoop.swift
//  
//
//  Created by Danny Sung on 12/18/2020.
//

import Foundation
import WorkQueue

public class WorkQueueRunLoop: WorkQueue {
    public let runLoop: RunLoop
    public let mode: RunLoop.Mode

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
