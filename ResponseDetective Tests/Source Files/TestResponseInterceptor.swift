//
//  TestResponseInterceptor.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import ResponseDetective

/// Intercepts the responses by storing them in an array.
@objc internal final class TestResponseInterceptor: ResponseInterceptorType {

	/// The intercepted responses store.
	internal var interceptedResponses = [ResponseRepresentation]()

	// MARK: ResponseInterceptorType implementation

	internal func canInterceptResponse(request: ResponseRepresentation) -> Bool {
		return true
	}

	internal func interceptResponse(response: ResponseRepresentation) {
		interceptedResponses.append(response)
	}
	
}
