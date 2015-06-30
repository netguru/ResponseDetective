//
//  JSONResponseInterceptor.swift
//  
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// Intercepts JSON responses.
public final class JSONResponseInterceptor: ResponseInterceptorType {

	/// The output stream used by the interceptor.
	public private(set) var outputStream: OutputStreamType

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

	// MARK: ResponseInterceptorType implementation

	public func canInterceptResponse(response: ResponseRepresentation) -> Bool {
		return map(response.contentType) { $0 == "application/json" } ?? false
	}

	public func interceptResponse(response: ResponseRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let jsonString = flatMap(flatMap(flatMap(response.bodyData, {
				NSJSONSerialization.JSONObjectWithData($0, options: nil, error: nil)
			}), {
				NSJSONSerialization.dataWithJSONObject($0, options: .PrettyPrinted, error: nil)
			}), {
				NSString(data: $0, encoding: NSUTF8StringEncoding) as? String
			}) {
				dispatch_async(dispatch_get_main_queue()) {
					self.outputStream.write(jsonString)
				}
			}
		}
	}
	
}
