//
//  WorkQueueDeferrable.swift
//  
//
//  Created by Danny Sung on 12/20/2020.
//

import Foundation
import WorkQueue

extension WorkQueueDispatch: WorkQueueDeferrable {
    public func asyncAfter(timeInterval: TimeInterval, execute block: @escaping () -> Void) -> WorkQueueItem {

        let state = WorkQueueDispatchItemState()

        let workItem = DispatchWorkItem() {
            state.isExecuting = true
            block()
            state.isFinished = true
            state.isExecuting = false
        }

        if timeInterval <= 0 {
            self.dispatchQueue.async(execute: workItem)
        } else {
            let deadline = DispatchTime.now() + .init(timeInterval)

            self.dispatchQueue.asyncAfter(deadline: deadline, execute: workItem)
        }

        return WorkQueueDispatchCancellableItem(workItem: workItem, state: state)
    }


}
