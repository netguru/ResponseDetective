//
//  XMLInterceptor.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Intercepts XML requests and responses.
public final class XMLInterceptor {

	/// The output stream used by the interceptor.
	public private(set) var outputStream: OutputStreamType

	// The acceptable content types.
	private let acceptableContentTypes = [
		"application/xml",
		"text/xml"
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

	/// Prettifies the XML string.
	///
	/// :param: string The XML string to prettify.
	///
	/// :returns: A prettified XML string.
	private func prettifyXMLString(string: String) -> String? {
		return rdv_prettifyXMLString(string)
	}

	/// Prettifies the XML data.
	///
	/// :param: data The XML data to prettify.
	///
	/// :returns: A prettified XML string.
	private func prettifyXMLData(data: NSData) -> String? {
		return flatMap(flatMap(data, {
			NSString(data: $0, encoding: NSUTF8StringEncoding) as String?
		}), {
			self.prettifyXMLString($0)
		})
	}

}

// MARK: -

extension XMLInterceptor: RequestInterceptorType {

	// MARK: RequestInterceptorType implementation

	public func canInterceptRequest(request: RequestRepresentation) -> Bool {
		return map(request.contentType) {
			contains(self.acceptableContentTypes, $0)
		} ?? false
	}

	public func interceptRequest(request: RequestRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let XMLString = flatMap(request.bodyData, { self.prettifyXMLData($0) }) {
				dispatch_async(dispatch_get_main_queue()) {
					self.outputStream.write(XMLString)
				}
			}
		}
	}

}

// MARK: -

extension XMLInterceptor: ResponseInterceptorType {

	// MARK: ResponseInterceptorType implementation

	public func canInterceptResponse(response: ResponseRepresentation) -> Bool {
		return map(response.contentType) {
			contains(self.acceptableContentTypes, $0)
		} ?? false
	}

	public func interceptResponse(response: ResponseRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let XMLString = flatMap(response.bodyData, { self.prettifyXMLData($0) }) {
				dispatch_async(dispatch_get_main_queue()) {
					self.outputStream.write(XMLString)
				}
			}
		}
	}
	
}
