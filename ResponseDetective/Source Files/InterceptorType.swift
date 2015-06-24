//
//  InterceptorType.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Instances of conforming types can be registered in the intercepting
/// NSURLProtocol and used to intercept NSURLRequests and NSHTTPURLResponses.
@objc public protocol InterceptorType {
	
	/// Whether the interceptor can intercept and process the outgoing request or the incoming response.
	///
	/// :param: content The request or the response in question.
	///
	/// :returns: A boolean indicating whether the request or the response should be
	/// intercepted and processed.
	func canIntercept(content: AnyObject) -> Bool
	
	/// Intercepts and processes the outgoing request or the incoming response. Preferably, all side
	/// effects should be executed asynchronously, so that the response doesn't
	/// get blocked.
	///
	/// :param: response The response to be processed.
	/// :param: data The data which arrived with the response.
	func intercept(content: AnyObject, data: NSData?)
	
	/// Intercepts and processes the incoming response error. Used only in response interceptors. Preferably, all
	/// side effects should be executed asynchronously, so that the response
	/// doesn't get blocked.
	///
	/// :param: response The response received along the error (if any).
	/// :param: error The associated error.

	optional func interceptResponseError(response: NSHTTPURLResponse?, _ error: NSError)
	
}
