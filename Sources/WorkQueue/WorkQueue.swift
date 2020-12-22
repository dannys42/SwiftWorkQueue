import Foundation

public protocol WorkQueue: AnyObject {
    @discardableResult
    func async(_ block: @escaping ()->Void) -> WorkQueueItem
}

public protocol WorkQueueItem {
    var isExecuting: Bool { get }
    var isFinished: Bool { get }
}

public class WorkQueueItemState {
    public var isExecuting: Bool = false
    public var isFinished: Bool = false

    public init() {
    }
}
