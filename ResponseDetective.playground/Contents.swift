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

class PlaygroundRequestInterceptor: InterceptorType {
	
	@objc func canIntercept(content: AnyObject) -> Bool {
		return true
	}
	
	@objc func intercept(content: AnyObject, _ data: NSData?) {
		print(content)
	}
	
}

class PlaygroundResponseInterceptor: InterceptorType {
	
	@objc func canIntercept(content: AnyObject) -> Bool {
		return true
	}
	
	@objc func intercept(content: AnyObject, _ data: NSData?) {
		print(content)
	}
	
	@objc func interceptResponseError(response: NSHTTPURLResponse?, _ error: NSError) {
		print((response, error))
	}
	
}


let requestToken = InterceptingProtocol.registerRequestInterceptor(PlaygroundRequestInterceptor())
let responseToken = InterceptingProtocol.registerResponseInterceptor(PlaygroundResponseInterceptor())

let session = NSURLSession(configuration: { () -> NSURLSessionConfiguration in
	let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
	configuration.protocolClasses = [InterceptingProtocol.self]
	return configuration
}())

let request = NSURLRequest(URL: NSURL(string: "http://httpbin.org/get")!)
session.dataTaskWithRequest(request).resume()
