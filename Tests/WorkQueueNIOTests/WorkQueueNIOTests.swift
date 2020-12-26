//
//  WorkQueueNIOTests.swift
//  
//
//  Created by Danny Sung on 12/23/2020.
//

import Foundation
import XCTest
import WorkQueueTestUtilities
import NIO
@testable import WorkQueue
@testable import WorkQueueNIO

final class WorkQueueNIOTests: WorkQueueTestCommon {

    override func setUp() {
        super.setUp()

        let loopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        self.workQueue = WorkQueueNIO(eventLoop: loopGroup.next())

//        self.willPerformAsync()
//        loopGroup.next().execute {
//            defer { self.didPerformAsync() }
//            print("hello")
//        }
//        self.willPerformAsync()
//        loopGroup.next().scheduleTask(in: .seconds(2)) {
//            defer { self.didPerformAsync() }
//            print("goodbye")
//        }
//
//        self.waitForAsyncComplete(4)

//        for eventLoop in loopGroup.makeIterator() {
//            let future = eventLoop.submit { () in
//
//            }
//            do {
//                try future.wait()
//            } catch {
//                print("wait failure: \(error.localizedDescription)")
//            }
//        }

//        self.workQueue = WorkQueueDispatch(queue: DispatchQueue(label: "\(Self.self)"))
    }
}
