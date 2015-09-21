//
//  HTMLInterceptor.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Intercepts HTML requests and responses.
public final class HTMLInterceptor {

	/// The output stream used by the interceptor.
	public private(set) var outputStream: OutputStreamType

	// The acceptable content types.
	private let acceptableContentTypes = [
		"text/html"
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

	// MARK: Prettifying

	/// Prettifies the HTML string.
	///
	/// - parameter string: The HTML string to prettify.
	///
	/// - returns: A prettified HTML string.
	private func prettifyHTMLString(string: String) -> String? {
		return rdv_prettifyHTMLString(string)
	}

	/// Prettifies the HTML data.
	///
	/// - parameter data: The HTML data to prettify.
	///
	/// - returns: A prettified HTML string.
	private func prettifyHTMLData(data: NSData) -> String? {
		return Optional(data).flatMap({
			NSString(data: $0, encoding: NSUTF8StringEncoding) as String?
		}).flatMap({
			self.prettifyHTMLString($0)
		})
	}

}

// MARK: -

extension HTMLInterceptor: RequestInterceptorType {

	// MARK: RequestInterceptorType implementation

	public func canInterceptRequest(request: RequestRepresentation) -> Bool {
		return request.contentType.map {
			self.acceptableContentTypes.contains($0)
		} ?? false
	}

	public func interceptRequest(request: RequestRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let HTMLString = request.bodyData.flatMap({
				self.prettifyHTMLData($0)
			}) {
				dispatch_async(dispatch_get_main_queue()) {
					self.outputStream.write(HTMLString)
				}
			}
		}
	}

}

// MARK: -

extension HTMLInterceptor: ResponseInterceptorType {

	// MARK: ResponseInterceptorType implementation

	public func canInterceptResponse(response: ResponseRepresentation) -> Bool {
		return response.contentType.map {
			self.acceptableContentTypes.contains($0)
		} ?? false
	}

	public func interceptResponse(response: ResponseRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let HTMLString = response.bodyData.flatMap({
				self.prettifyHTMLData($0)
			}) {
				dispatch_async(dispatch_get_main_queue()) {
					self.outputStream.write(HTMLString)
				}
			}
		}
	}
	
}
