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

	/// Initializes the interceptor with a output stream.
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

	/// Prettifies the HTML string.
	///
	/// :param: string The HTML string to prettify.
	///
	/// :returns: A prettified HTML string.
	private func prettifyHTMLString(string: String) -> String? {
		return rdv_prettifyHTMLString(string)
	}

	/// Prettifies the HTML data.
	///
	/// :param: data The HTML data to prettify.
	///
	/// :returns: A prettified HTML string.
	private func prettifyHTMLData(data: NSData) -> String? {
		return flatMap(flatMap(data, {
			NSString(data: $0, encoding: NSUTF8StringEncoding) as String?
		}), {
			self.prettifyHTMLString($0)
		})
	}

}

// MARK: -

extension HTMLInterceptor: RequestInterceptorType {

	// MARK: RequestInterceptorType implementation

	public func canInterceptRequest(request: RequestRepresentation) -> Bool {
		return map(request.contentType) {
			contains(self.acceptableContentTypes, $0)
		} ?? false
	}

	public func interceptRequest(request: RequestRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let HTMLString = flatMap(request.bodyData, {
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
		return map(response.contentType) {
			contains(self.acceptableContentTypes, $0)
		} ?? false
	}

	public func interceptResponse(response: ResponseRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let HTMLString = flatMap(response.bodyData, {
				self.prettifyHTMLData($0)
			}) {
				dispatch_async(dispatch_get_main_queue()) {
					self.outputStream.write(HTMLString)
				}
			}
		}
	}
	
}
