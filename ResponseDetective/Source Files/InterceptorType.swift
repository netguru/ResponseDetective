//
//  InterceptorType.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Instances of conforming types can be registered in the intercepting
/// NSURLProtocol and used to intercept NSURLRequests.
public protocol RequestInterceptorType {

	/// Whether the interceptor can intercept and process the outgoing request.
	///
	/// :param: request The request in question.
	///
	/// :returns: A boolean indicating whether the request should be
	/// intercepted and processed.
	func canInterceptRequest(request: NSURLRequest) -> Bool

	/// Intercepts and processes the outgoing request. Preferably, all side
	/// effects should be executed asynchronously, so that the request doesn't
	/// get blocked.
	///
	/// :param: request The request to be processed.
	func interceptRequest(request: NSURLRequest)

}

/// Instances of conforming types can be registered in the intercepting
/// NSURLProtocol and used to intercept NSHTTPURLResponses.
public protocol ResponseInterceptorType {

	/// Whether the interceptor can intercept and process the incoming response.
	///
	/// :param: response The response in question.
	///
	/// :returns: A boolean indicating whether the response should be
	/// intercepted and processed.
	func canInterceptResponse(response: NSHTTPURLResponse) -> Bool

	/// Intercepts and processes the incoming response. Preferably, all side
	/// effects should be executed asynchronously, so that the response doesn't
	/// get blocked.
	///
	/// :param: response The response to be processed.
	/// :param: data The data which arrived with the response.
	func interceptResponse(response: NSHTTPURLResponse, _ data: NSData)

	/// Intercepts and processes the incoming response error. Preferably, all
	/// side effects should be executed asynchronously, so that the response
	/// doesn't get blocked.
	///
	/// :param: response The response received along the error (if any).
	/// :param: error The associated error.
	func interceptResponseError(response: NSHTTPURLResponse?, _ error: NSError)

}
