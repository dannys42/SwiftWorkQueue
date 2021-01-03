//
//  WorkQueueOperation.swift
//  
//
//  Created by Danny Sung on 12/18/2020.
//

import Foundation
import WorkQueue


public class WorkQueueOperationItem: WorkQueueItem {
    public let operation: Operation

    public init(operation: Operation) {
        self.operation = operation
    }

    public var isExecuting: Bool {
        return self.operation.isExecuting
    }

    public var isFinished: Bool {
        return self.operation.isFinished
    }

    public func cancel() {
        self.operation.cancel()
    }

    public var isCancelled: Bool {
        return self.operation.isCancelled
    }


}

/// `WorkQueueOperation` is a `WorkQueue` implementation that executes deferred code in a `OperationQueue`
public class WorkQueueOperation: WorkQueue {
    public let operationQueue: OperationQueue

    /// Specifies this `WorkQueue` relies on the given `OperationQueue`
    /// - Parameter operationQueue: `OperationQueue` to use
    required public init(operationQueue: OperationQueue) {
        self.operationQueue = operationQueue
    }

    /// Creates a `WorkQueue` with a custom `OperationQueue`
    /// - Parameter label: Label to use with the `OperationQueue`
    convenience init(label: String) {
        let opQ = OperationQueue()
        opQ.name = label
        self.init(operationQueue: opQ)
    }


    public func async(_ block: @escaping () -> Void) -> WorkQueueItem {
        let op = Operation()
        op.name = "\(Self.self).\(#function).\(#line)"
        op.completionBlock = block
        self.operationQueue.addOperation(block)

        return WorkQueueOperationItem(operation: op)
    }
}
