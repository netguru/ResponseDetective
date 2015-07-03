//
//  JSONInterceptor.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Intercepts JSON requests and responses.
public final class JSONInterceptor {

	/// The output stream used by the interceptor.
	public private(set) var outputStream: OutputStreamType

	// The acceptable content types.
	private let acceptableContentTypes = [
		"application/json"
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

	/// Prettifies the JSON data.
	///
	/// :param: data The JSON data to prettify.
	///
	/// :returns: A prettified JSON string.
	private func prettifyJSONData(data: NSData) -> String? {
		return flatMap(flatMap(flatMap(data, {
			NSJSONSerialization.JSONObjectWithData($0, options: nil, error: nil)
		}), {
			NSJSONSerialization.dataWithJSONObject($0, options: .PrettyPrinted, error: nil)
		}), {
			NSString(data: $0, encoding: NSUTF8StringEncoding) as? String
		})
	}

	/// Prettifies the JSON data stream.
	///
	/// :param: stream The JSON data stream to prettify.
	///
	/// :returns: A prettified JSON stream.
	private func prettifyJSONStream(stream: NSInputStream) -> String? {
		return flatMap(flatMap(flatMap(stream, {
			NSJSONSerialization.JSONObjectWithStream($0, options: nil, error: nil)
		}), {
			NSJSONSerialization.dataWithJSONObject($0, options: .PrettyPrinted, error: nil)
		}), {
			NSString(data: $0, encoding: NSUTF8StringEncoding) as? String
		})
	}

}

// MARK: -

extension JSONInterceptor: RequestInterceptorType {

	// MARK: RequestInterceptorType implementation

	public func canInterceptRequest(request: RequestRepresentation) -> Bool {
		return map(request.contentType) {
			contains(self.acceptableContentTypes, $0)
		} ?? false
	}

	public func interceptRequest(request: RequestRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let jsonString = flatMap(request.bodyStream, { self.prettifyJSONStream($0) }) {
				dispatch_async(dispatch_get_main_queue()) {
					self.outputStream.write(jsonString)
				}
			}
		}
	}

}

// MARK: -

extension JSONInterceptor: ResponseInterceptorType {

	// MARK: ResponseInterceptorType implementation

	public func canInterceptResponse(response: ResponseRepresentation) -> Bool {
		return map(response.contentType) {
			contains(self.acceptableContentTypes, $0)
		} ?? false
	}

	public func interceptResponse(response: ResponseRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let jsonString = flatMap(response.bodyData, { self.prettifyJSONData($0) }) {
				dispatch_async(dispatch_get_main_queue()) {
					self.outputStream.write(jsonString)
				}
			}
		}
	}

}
