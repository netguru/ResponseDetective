//
//  TestRequestInterceptor.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import ResponseDetective

/// Intercepts the requests by storing them in an array.
internal final class TestRequestInterceptor: RequestInterceptorType {

	/// The intercepted requests store.
	internal var interceptedRequests = [RequestRepresentation]()

	// MARK: RequestInterceptorType implementation

	internal func canInterceptRequest(request: RequestRepresentation) -> Bool {
		return true
	}

	internal func interceptRequest(request: RequestRepresentation) {
		interceptedRequests.append(request)
	}
	
}
