//
//  TestErrorInterceptor.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import ResponseDetective

/// Intercepts the response errors by storing them in an array.
@objc internal final class TestErrorInterceptor: ErrorInterceptorType {

	/// The intercepted requests store.
	internal var interceptedErrors = [(NSError, ResponseRepresentation?)]()

	// MARK: ErrorInterceptorType implementation

	internal func interceptError(error: NSError, _ response: ResponseRepresentation?) {
		interceptedErrors.append((error, response))
	}
	
}
