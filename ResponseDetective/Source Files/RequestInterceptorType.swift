//
//  RequestInterceptorType.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Instances of conforming types can be registered in the intercepting
/// NSURLProtocol and used to intercept NSURLRequests.
public protocol RequestInterceptorType: class {

	/// Whether the interceptor can intercept and process the outgoing request.
	///
	/// :param: request The request in question.
	///
	/// :returns: A boolean indicating whether the request should be
	/// intercepted and processed.
	func canInterceptRequest(request: RequestRepresentation) -> Bool

	/// Intercepts and processes the outgoing request. Preferably, all side
	/// effects should be executed asynchronously, so that the request doesn't
	/// get blocked.
	///
	/// :param: request The request to be processed.
	func interceptRequest(request: RequestRepresentation)

}
