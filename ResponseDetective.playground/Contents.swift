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


struct PlaygroundInterceptor: RequestInterceptorType, ResponseInterceptorType, ErrorInterceptorType {
	
	func canInterceptRequest(request: RequestRepresentation) -> Bool {
		return true
	}
	
	func interceptRequest(request: RequestRepresentation) {
		print(request.method)
		print(request.url)
		print(request.headers)
		print(request.contentType)
		print(request.bodyStream)
		print(request.bodyData)
		print(request.bodyUTF8String)
	}
	
	func canInterceptResponse(response: ResponseRepresentation) -> Bool {
		return true
	}
	
	func interceptResponse(response: ResponseRepresentation) {
		print(response.statusCode)
		print(response.url)
		print(response.headers)
		print(response.contentType)
		print(response.bodyData)
		print(response.bodyUTF8String)
	}
	
	func interceptError(error: NSError, _ response: ResponseRepresentation?) {
		print(error.description)
		if let response = response {
			print(response.statusCode)
			print(response.url)
			print(response.headers)
			print(response.contentType)
			print(response.bodyData)
			print(response.bodyUTF8String)
		}
	}
}

let requestToken = InterceptingProtocol.registerRequestInterceptor(PlaygroundInterceptor())
let responseToken = InterceptingProtocol.registerResponseInterceptor(PlaygroundInterceptor())
let errorToken = InterceptingProtocol.registerErrorInterceptor(PlaygroundInterceptor())

let session = NSURLSession(configuration: { () -> NSURLSessionConfiguration in
	let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
	configuration.protocolClasses = [InterceptingProtocol.self]
	return configuration
}())

let request = NSURLRequest(URL: NSURL(string: "http://httpbin.org/get")!)
session.dataTaskWithRequest(request).resume()
