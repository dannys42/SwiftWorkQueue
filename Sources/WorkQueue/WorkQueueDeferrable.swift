//
//  WorkQueueDeferrable.swift
//  
//
//  Created by Danny Sung on 12/20/2020.
//

import Foundation

/// A `WorkQueue` that supports executing tasks after a specified time
public protocol WorkQueueDeferrable: WorkQueue {
    /// Execute a block after a specified time
    /// - Parameters:
    ///   - timeInterval: Number of seconds before executing block
    ///   - execute: block to execute
    /// Returns: `WorkQueueItem` that may be used to determine status or cancel the block.
    @discardableResult
    func asyncAfter(timeInterval: TimeInterval, execute: @escaping ()->Void) -> WorkQueueItem
}
