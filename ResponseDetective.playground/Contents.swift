//
// ResponseDetective.playground
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
import ResponseDetective
import XCPlayground

// Enable indefinite execution so that requests complete before the playground
// is killed.

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: ---

// Start by creating a session configuration that includes ResponseDetective's
// interception mechanisms.

let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
ResponseDetective.enableInURLSessionConfiguration(configuration)

// And use the above configuration to create your session instance.

let session = NSURLSession(configuration: configuration)

//: ---

// Now, just create a request and resume its session data task.

let request = NSURLRequest(URL: NSURL(string: "https://httpbin.org/get")!)
session.dataTaskWithRequest(request).resume()

// Watch the console! 🎉
