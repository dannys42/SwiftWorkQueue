//
//  WorkQueueTestCommon.swift
//  
//
//  Created by Danny Sung on 12/23/2020.
//

import Foundation
import XCTest
@testable import WorkQueue

open class WorkQueueTestCommon: XCTestCase {
    open var workQueue: WorkQueue!
    open var asyncGroup = DispatchGroup()

    open override func setUp() {
        super.setUp()
    }
    
    open override func tearDown() {
        super.tearDown()
    }

    open func willPerformAsync() {
        self.asyncGroup.enter()
    }
    open func didPerformAsync() {
        self.asyncGroup.leave()
    }
    open func waitForAsyncComplete(_ timeInterval: TimeInterval) -> DispatchTimeoutResult {
        return self.asyncGroup.wait(timeout: .now() + timeInterval)
    }

    public func testThat_BlockExecutes_ExactlyOnce() throws {
        try XCTSkipIf(self.workQueue == nil)
        let timeout: TimeInterval = 2
        let expectedCount = 1
        var executeCount = 0

        self.willPerformAsync()
        self.workQueue.async {
            defer { self.didPerformAsync() }
            executeCount += 1
        }

        let waitResult = self.waitForAsyncComplete(timeout)

        XCTAssertEqual(waitResult, .success, "Should not have timed out.")
        XCTAssertEqual(executeCount, expectedCount, "Should have execited block exactly once")
    }

    public func testThat_BlockExecutes_ExactlyOnce_AfterTime() throws {
        guard let workQueue = self.workQueue as? WorkQueueDeferrable else {
            _ = XCTSkip("This test is only valid for WorkQueueDeferrable WorkQueues.")
            return
        }

        let delayTime: TimeInterval = 1.25
        let maxTime: TimeInterval = 2
        let timeout: TimeInterval = delayTime + 3
        let startTimestamp = Date().timeIntervalSince1970
        var endTimeStamp: TimeInterval = .nan
        let expectedCount = 1
        var executeCount = 0

        self.willPerformAsync()
        workQueue.asyncAfter(timeInterval: delayTime) {
            defer { self.didPerformAsync() }
            executeCount += 1
            endTimeStamp = Date().timeIntervalSince1970
            Thread.sleep(forTimeInterval: delayTime)
        }

        let waitResult = self.waitForAsyncComplete(timeout)
        let duration = endTimeStamp - startTimestamp

        XCTAssertEqual(waitResult, .success, "Should not have timed out.")
        XCTAssertEqual(executeCount, expectedCount, "Should have execited block exactly once")
        XCTAssert(duration > delayTime, "Should not have executed in less than \(delayTime) seconds.")

        if duration > maxTime {
            print("warning: duration > \(maxTime) seconds.  While there is no guarantee of execution time, this may need to be looked at.")
        }
    }
}
