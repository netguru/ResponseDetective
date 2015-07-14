//
//  ResponseInterceptorType.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

/// Instances of conforming types can be registered in the intercepting
/// NSURLProtocol and used to intercept NSHTTPURLResponses.
public protocol ResponseInterceptorType: class {

	/// Whether the interceptor can intercept and process the incoming response.
	///
	/// :param: response The response in question.
	///
	/// :returns: A boolean indicating whether the response should be
	/// intercepted and processed.
	func canInterceptResponse(response: ResponseRepresentation) -> Bool

	/// Intercepts and processes the incoming response. Preferably, all side
	/// effects should be executed asynchronously, so that the response doesn't
	/// get blocked.
	///
	/// :param: response The response to be processed.
	func interceptResponse(response: ResponseRepresentation)

}
