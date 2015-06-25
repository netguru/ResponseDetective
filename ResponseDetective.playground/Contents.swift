//
//  ResponseDetective.playground
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import ResponseDetective
import XCPlayground

// Enable indefinite execution so that requests complete before the playground
// is killed.
XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)

// /////////////////////////////////////////////////////////////////////////////

struct PlaygroundInterceptor: RequestInterceptorType, ResponseInterceptorType {

	func canInterceptRequest(request: NSURLRequest) -> Bool {
		return true
	}

	func interceptRequest(request: NSURLRequest) {
		print(request)
	}

	func canInterceptResponse(response: NSHTTPURLResponse) -> Bool {
		return true
	}

	func interceptResponse(response: NSHTTPURLResponse, _ data: NSData) {
		print((response, data))
	}

	func interceptResponseError(response: NSHTTPURLResponse?, _ error: NSError) {
		print((response, error))
	}

}

let requestToken = InterceptingProtocol.registerRequestInterceptor(PlaygroundInterceptor())
let responseToken = InterceptingProtocol.registerResponseInterceptor(PlaygroundInterceptor())

let session = NSURLSession(configuration: { () -> NSURLSessionConfiguration in
	let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
	configuration.protocolClasses = [InterceptingProtocol.self]
	return configuration
}())

let request = NSURLRequest(URL: NSURL(string: "http://httpbin.org/get")!)
session.dataTaskWithRequest(request).resume()
