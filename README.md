<p align="center">
<a href="https://github.com/dannys42/SwiftWorkQueue/actions?query=workflow%3ASwift"><img src="https://github.com/dannys42/SwiftWorkQueue/workflows/Swift/badge.svg" alt="build status"></a>
<img src="https://img.shields.io/badge/os-macOS-green.svg?style=flat" alt="macOS">
<img src="https://img.shields.io/badge/os-iOS-green.svg?style=flat" alt="iOS">
<img src="https://img.shields.io/badge/os-linux-green.svg?style=flat" alt="Linux">
<a href="LICENSE"><img src="https://img.shields.io/badge/license-Apache2-blue.svg?style=flat" alt="Apache 2"></a>
<br/>
<a href="https://swiftpackageindex.com/dannys42/SwiftWorkQueue"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdannys42%SwiftWorkQueue%2Fbadge%3Ftype%3Dswift-versions"></a>
<a href="https://swiftpackageindex.com/dannys42/SwiftWorkQueue"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdannys42%2F SwiftWorkQueue%2Fbadge%3Ftype%3Dplatforms"></a>
</p>


# SwiftWorkQueue
`WorkQueue` is a set of protocols that help to abstract code deferral.  There are implementations to support `RunLoop`, `DispatchQueue`, `OperationQueue`, NIO `EventLoop`.

Swift has many code deferal mechanisms (as listed above).  Unfortunately when library authors need to perform defered operations (e.g. typically for async methods), they have to make a choice as to whether to use `DispatchQueue`, `OperationQueue`, `RunLoop`, etc.

However an application may be composed of many such libraries, where each author has chosen a different mechanism.  This may lead to inefficient use of CPU resources.  `SwiftWorkQueue` aims to resolve this problem and allow the application developer to make the choice for their application.

Design goals:

 - Allow library authors to have a generic representation of code deferral, so that application developers can make the decision as to which method they prefer
 - A modular set of protocols supporting a variety of queue types, such as calling after a timeout.


## Usage

### Library Authors

Typically, when a library author needs to perform deferred operations, they decide the code deferal mechanism (e.g. `DispatchQueue`).  This will typically look like this:


```swift
import Foundation

class SomeObject {
	private let dispatchQueue: DispatchQueue
	
	init(dispatchQueue: DispatchQueue? = nil) {

		// use a custom queue if one was not provided	
		self.dispatchQueue = dispatchQueue ?? DispatchQueue()
	}


	func someAsyncCall(_ completion: @escaping ()->Void) {
		self.dispatchQueue.async {
			// perform some sort of task in the background
			completion()
		}
	}
}

```

To use `WorkQueue`, the change for the library author is minimal:

```swift

import WorkQueue
import WorkQueueDispatch

class SomeObject {
	private let workQueue: WorkQueue
	
	init(workQueue: WorkQueue? = nil) {

		// use a custom DispatchQueue if no WorkQueue was provided	
		self.workQueue = workQueue ?? WorkQueueDispatch(queue: DispatchQueue(label: "SomeObject default"))
	}


	func someAsyncCall(_ completion: @escaping ()->Void) {
		self.workQueue.async {
			// perform some sort of task in the background
			completion()
		}
	}
}

```


### Application Developers

Given the class above, the application developer can choose the deferal mechanism they want:

```swift
import WorkQueue
// application author will typically pick one of the following
import WorkQueueDispatch  	// To support DispatchQueue 
import WorkQueueOperation 	// To support OperationQueue
import WorkQueueRunLoop  	// To support RunLoop
import WorkQueueNIO		  	// To support NIO 

class MyApplication {
	let workQueue: WorkQueue
	
	init() {
		self.workQueue = WorkQueueRunLoop(runLoop: .main)
	}
	
	func run() {
		SomeObject().someAsyncCall() {
			// completion handler
		}
	}
}

```

Even though `SomeObject()`'s default deferal mechanism was to use a `DispatchQueue`, in this case, the application author has chosen to use `RunLoop`.  `.someAsyncCall()` and the subsequent completion handler will be called on the `RunLoop` specified.

## Installation

Add the `SwiftWorkQueue ` package to the dependencies within your application's `Package.swift` file.  Substitute "x.y.z" with the latest `SwiftWorkQueue ` [release](https://github.com/dannys42/SwiftWorkQueue/releases).

```swift
.package(url: "https://github.com/dannys42/SwiftWorkQueue.git", from: "x.y.z")
```

Add `ClosureChain` to your target's dependencies:

```swift
.target(name: "example", dependencies: ["SwiftWorkQueue"]),
```

### Cocoapods

Add `SwiftWorkQueue ` to your Podfile:

```ruby
pod `SwiftWorkQueue `
```

## API Documentation

For more information visit our [API reference](https://dannys42.github.io/SwiftWorkQueue/).

## License
This library is licensed under Apache 2.0. The full license text is available in [LICENSE](LICENSE).
