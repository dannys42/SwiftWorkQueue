//
//  WorkQueueDispatchTests.swift
//  
//
//  Created by Danny Sung on 12/23/2020.
//

import Foundation
import XCTest
import WorkQueueTestUtilities
@testable import WorkQueue
@testable import WorkQueueDispatch

final class WorkQueueDispatchTests: WorkQueueTestCommon {

    override func setUp() {
        super.setUp()

        self.workQueue = WorkQueueDispatch(queue: DispatchQueue(label: "\(Self.self)"))
    }
}
