//
//  WorkQueueDeferrable.swift
//  
//
//  Created by Danny Sung on 12/20/2020.
//

import Foundation

public protocol WorkQueueDeferrable {
    @discardableResult
    func asyncAfter(timeInterval: TimeInterval, execute: @escaping ()->Void) -> WorkQueueItem
}
