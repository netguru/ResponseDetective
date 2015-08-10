//
//  PlainTextInterceptor.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Intercepts plain text requests and responses.
@objc(RDVPlainTextInterceptor) public final class PlainTextInterceptor {
	
	/// The output stream used by the interceptor.
	public private(set) var outputStream: OutputStreamType
	
	// The acceptable content types.
	private let acceptableContentTypes = [
		"text/plain"
	]
	
	// MARK: Initialization
	
	/// Initializes the interceptor with an output stream.
	///
	/// :param: outputStream The output stream to be used.
	public init(outputStream: OutputStreamType) {
		self.outputStream = outputStream
	}
	
	/// Initializes the interceptor with a Println output stream.
	public convenience init() {
		self.init(outputStream: PrintlnOutputStream())
	}
	
	// MARK: Prettifying
	
	/// Prettifies the plain text data.
	///
	/// :param: data The plain text data to prettify.
	///
	/// :returns: A prettified plain text string.
	private func prettifyPlainTextData(data: NSData) -> String? {
		return flatMap(data) {
			NSString(data: $0, encoding: NSUTF8StringEncoding) as String?
		}
	}
}

// MARK: -

extension PlainTextInterceptor: RequestInterceptorType {
	
	// MARK: RequestInterceptorType implementation
	
	public func canInterceptRequest(request: RequestRepresentation) -> Bool {
		return map(request.contentType) {
			contains(self.acceptableContentTypes, $0)
		} ?? false
	}
	
	public func interceptRequest(request: RequestRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let plainTextString = flatMap(request.bodyData, {
				self.prettifyPlainTextData($0)
			}) {
				dispatch_async(dispatch_get_main_queue()) {
					self.outputStream.write(plainTextString)
				}
			}
		}
	}
	
}

// MARK: -

extension PlainTextInterceptor: ResponseInterceptorType {
	
	// MARK: ResponseInterceptorType implementation
	
	public func canInterceptResponse(response: ResponseRepresentation) -> Bool {
		return map(response.contentType) {
			contains(self.acceptableContentTypes, $0)
		} ?? false
	}
	
	public func interceptResponse(response: ResponseRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let plainTextString = flatMap(response.bodyData, {
				self.prettifyPlainTextData($0)
			}) {
				dispatch_async(dispatch_get_main_queue()) {
					self.outputStream.write(plainTextString)
				}
			}
		}
	}
	
}
