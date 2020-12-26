//
//  WorkQueueOperationTests.swift
//  
//
//  Created by Danny Sung on 12/23/2020.
//

import Foundation
import XCTest
import WorkQueueTestUtilities
@testable import WorkQueue
@testable import WorkQueueOperation

final class WorkQueueOperationTests: WorkQueueTestCommon {

    override func setUp() {
        super.setUp()

        self.workQueue = WorkQueueOperation(label: "\(Self.self)")
    }
}
