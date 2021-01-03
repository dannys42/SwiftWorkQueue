import Foundation

/// WorkQueue is intended to abstract code deferal.
public protocol WorkQueue: AnyObject {
    /// Perform a deferred task.  This may or may not be on a separate thread depending on the `WorkQueue` implementation.
    /// - Parameter block: Code to execute "later"
    /// Returns: `WorkQueueItem` that may be used to determine status or cancel the block.
    @discardableResult
    func async(_ block: @escaping ()->Void) -> WorkQueueItem
}

/// Keeps track of a requested deferal operation
public protocol WorkQueueItem {
    /// Determine whether the `WorkQueueItem` is currently executing
    var isExecuting: Bool { get }

    /// Determine whether the `WorkQueueItem` has finished executing (a cancelled item may or may not report as finished)
    var isFinished: Bool { get }

    /// Determine whether the `WorkQueueItem` has been cancelled
    var isCancelled: Bool { get }

    /// If the `WorkQueueItem` has not executed yet, this will cancel the `WorkQueueItem` and prevent it from executing.  (If supported by the `WorkQueue` implementation)
    func cancel()
}

/// A convenience class for `WorkQueue` implementations to help maintain execution state.
public class WorkQueueItemState {
    public var isExecuting: Bool = false
    public var isFinished: Bool = false

    public init() {
    }
}
