# SwiftWorkQueue
`WorkQueue` is a library to abstract code deferral (RunLoops, DispatchQueues, OperationQueues, EventLoops).

Design goals:
 - Allow library authors to have a generic representation of code deferral, so that application developers can make the decision as to which method they prefer
 - A modular framework supporting a variety of queue types that may or may not support cancelling
 
