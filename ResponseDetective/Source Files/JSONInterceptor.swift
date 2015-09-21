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

	/// Prettifies the JSON data.
	///
	/// - parameter data: The JSON data to prettify.
	///
	/// - returns: A prettified JSON string.
	private func prettifyJSONData(data: NSData) -> String? {
		return Optional(data).flatMap({
			try? NSJSONSerialization.JSONObjectWithData($0, options: [])
		}).flatMap({
			try? NSJSONSerialization.dataWithJSONObject($0, options: .PrettyPrinted)
		}).flatMap({
			NSString(data: $0, encoding: NSUTF8StringEncoding) as? String
		})
	}

	/// Prettifies the JSON data stream.
	///
	/// - parameter stream: The JSON data stream to prettify.
	///
	/// - returns: A prettified JSON stream.
	private func prettifyJSONStream(stream: NSInputStream) -> String? {
		return Optional(stream).flatMap({
			stream.open()
			let object: AnyObject? = try? NSJSONSerialization.JSONObjectWithStream($0, options: [])
			stream.close()
			return object
		}).flatMap({
			try? NSJSONSerialization.dataWithJSONObject($0, options: .PrettyPrinted)
		}).flatMap({
			NSString(data: $0, encoding: NSUTF8StringEncoding) as? String
		})
	}

}

// MARK: -

extension JSONInterceptor: RequestInterceptorType {

	// MARK: RequestInterceptorType implementation

	public func canInterceptRequest(request: RequestRepresentation) -> Bool {
		return request.contentType.map {
			self.acceptableContentTypes.contains($0)
		} ?? false
	}

	public func interceptRequest(request: RequestRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let jsonString = request.bodyStream.flatMap({ self.prettifyJSONStream($0) }) {
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
		return response.contentType.map {
			self.acceptableContentTypes.contains($0)
		} ?? false
	}

	public func interceptResponse(response: ResponseRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let jsonString = response.bodyData.flatMap({ self.prettifyJSONData($0) }) {
				dispatch_async(dispatch_get_main_queue()) {
					self.outputStream.write(jsonString)
				}
			}
		}
	}

}
