//
//  JSONRequestInterceptor.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

public final class JSONRequestInterceptor: RequestInterceptorType {

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

	// MARK: RequestInterceptorType implementation

	public func canInterceptRequest(request: RequestRepresentation) -> Bool {
		return map(request.contentType) { $0 == "application/json" } ?? false
	}

	public func interceptRequest(request: RequestRepresentation) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let jsonString = flatMap(flatMap(flatMap(request.body, {
				NSJSONSerialization.JSONObjectWithData($0, options: nil, error: nil)
			}), {
				NSJSONSerialization.dataWithJSONObject($0, options: .PrettyPrinted, error: nil)
			}), {
				NSString(data: $0, encoding: NSUTF8StringEncoding) as? String
			}) {
				self.outputStream.write(jsonString)
			}
		}
	}

}
