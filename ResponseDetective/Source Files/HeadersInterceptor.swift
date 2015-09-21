//
//  HeadersInterceptor.swift
//  
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Intercepts all requests and responses and displays their metadata, including
/// errors.
public final class HeadersInterceptor {

	/// The output stream used by the interceptor.
	public private(set) var outputStream: OutputStreamType

	// The acceptable content types.
	private let acceptableContentTypes = [
		"application/json"
	]

	// MARK: Initialization

	/// Initializes the interceptor with an output stream.
	///
	/// - parameter outputStream: The output stream to be used.
	public init(outputStream: OutputStreamType) {
		self.outputStream = outputStream
	}

	/// Initializes the interceptor with a Println output stream.
	public convenience init() {
		self.init(outputStream: PrintlnOutputStream())
	}
	
}

// MARK: -

extension HeadersInterceptor: RequestInterceptorType {

	// MARK: RequestInterceptorType implementation

	public func canInterceptRequest(request: RequestRepresentation) -> Bool {
		return true
	}

	public func interceptRequest(request: RequestRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			let headersString = (request.headers.map({ (key, value) in
				"\(key): \(value)"
			}) as NSArray).componentsJoinedByString("\n") as String
			dispatch_async(dispatch_get_main_queue()) {
				self.outputStream.write("\(request.method) \(request.url)")
				self.outputStream.write(headersString)
			}
		}
	}

}

// MARK: -

extension HeadersInterceptor: ResponseInterceptorType {

	// MARK: ResponseInterceptorType implementation

	public func canInterceptResponse(response: ResponseRepresentation) -> Bool {
		return true
	}

	public func interceptResponse(response: ResponseRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			let headersString = (response.headers.map({ (key, value) in
				"\(key): \(value)"
			}) as NSArray).componentsJoinedByString("\n") as String
			dispatch_async(dispatch_get_main_queue()) {
				self.outputStream.write("\(response.statusCode) \(NSHTTPURLResponse.localizedStringForStatusCode(response.statusCode))")
				self.outputStream.write(headersString)
			}
		}
	}
	
}

// MARK: -

extension HeadersInterceptor: ErrorInterceptorType {

	// MARK: ErrorInterceptorType implementation

	public func interceptError(error: NSError, _ response: ResponseRepresentation?) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let response = response {
				let headersString = (response.headers.map({ (key, value) in
					"\(key): \(value)"
				}) as NSArray).componentsJoinedByString("\n") as String
				dispatch_async(dispatch_get_main_queue()) {
					self.outputStream.write("\(response.statusCode) \(NSHTTPURLResponse.localizedStringForStatusCode(response.statusCode))")
					self.outputStream.write(headersString)
				}
			}
			dispatch_async(dispatch_get_main_queue()) {
				self.outputStream.write(error.description)
			}
		}
	}
	
}
