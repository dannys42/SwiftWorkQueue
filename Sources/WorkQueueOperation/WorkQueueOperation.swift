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
}

public class WorkQueueOperationCancellableItem: WorkQueueOperationItem, WorkQueueCancellableItem {

    public func cancel() {
        self.operation.cancel()
    }

    public var isCancelled: Bool {
        return self.operation.isCancelled
    }


}

public class WorkQueueOperation: WorkQueue {
    public let operationQueue: OperationQueue

    required public init(operationQueue: OperationQueue) {
        self.operationQueue = operationQueue
    }

    convenience init(label: String) {
        let opQ = OperationQueue()
        opQ.name = label
        self.init(operationQueue: opQ)
    }

}

extension WorkQueueOperation: WorkQueueCancellable {
    public func async(w_ block: @escaping () -> Void) -> WorkQueueCancellableItem {
        let op = Operation()
        op.name = "\(Self.self).\(#function).\(#line)"
        op.completionBlock = block
        self.operationQueue.addOperation(block)

        return WorkQueueOperationCancellableItem(operation: op)
    }
}
