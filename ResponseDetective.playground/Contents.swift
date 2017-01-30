//
// ResponseDetective.playground
//
// Copyright (c) 2016-2017 Netguru Sp. z o.o. All rights reserved.
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

let configuration = URLSessionConfiguration.default
ResponseDetective.enable(inConfiguration: configuration)

// And use the above configuration to create your session instance.

let session = URLSession(configuration: configuration)

//: ---

// Now, just create a request and resume its session data task.

let request = URLRequest(url: URL(string: "https://httpbin.org/get")!)
session.dataTask(with: request).resume()

// Watch the console