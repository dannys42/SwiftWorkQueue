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
@testable import WorkQueueRunLoop

final class WorkQueueRunLoopTests: WorkQueueTestCommon {

    override func setUp() {
        super.setUp()

        self.workQueue = WorkQueueRunLoop(runLoop: .main)
    }

    override func waitForAsyncComplete(_ timeInterval: TimeInterval) -> DispatchTimeoutResult {
        let timeStep: TimeInterval = 0.1
        let startTime = Date().timeIntervalSince1970
        var timeoutResult = DispatchTimeoutResult.timedOut

        repeat {
            timeoutResult = self.asyncGroup.wait(timeout: .now() + timeStep)
            RunLoop.main.run(until: Date())
        } while (Date().timeIntervalSince1970 - startTime) < timeInterval && timeoutResult == .timedOut

        return timeoutResult
    }

}
