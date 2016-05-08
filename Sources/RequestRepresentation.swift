//
// RequestRepresentation.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// Represents a foundation URL request.
@objc(RDTRequestRepresentation) public final class RequestRepresentation: NSObject {
	
	/// A unique identifier of the request.
	public let identifier: String
	
	/// The HTTP method of the request.
	public let method: String
	
	/// The resolved URL string of the request.
	public let URLString: String
	
	/// The HTTP headers of the request.
	public let headers: [String: String]
	
	/// The content type of the request.
	public let contentType: String
	
	/// The raw body data of the request.
	public let body: NSData?
	
	/// The parsed body of the request.
	public let deserializedBody: String?

	/// Initializes the receiver.
	///
	/// - Parameters:
	///     - identifier: A unique identifier of the request.
	///     - method: he HTTP method of the request.
	///     - URLString: The resolved URL string of the request.
	///     - headers: The HTTP headers of the request.
	///     - contentType: The content type of the request.
	///     - body: The raw body data of the request.
	///     - deserializedBody: The parsed body of the request.
	public init(
		identifier: String,
		method: String,
		URLString: String,
		headers: [String: String],
		contentType: String,
		body: NSData?,
		deserializedBody: String?
	) {
		self.identifier = identifier
		self.method = method
		self.URLString = URLString
		self.headers = headers
		self.contentType = contentType
		self.body = body
		self.deserializedBody = deserializedBody
	}

	/// Initializes the receiver.
	///
	/// - Parameters:
	///     - identifier: A unique identifier of the request.
	///     - request: The URL request instance.
	///     - deserializedBody: The parsed body of the request.
	public convenience init(identifier: String, request: NSURLRequest, deserializedBody: String?) {
		self.init(
			identifier: identifier,
			method: request.HTTPMethod ?? "GET",
			URLString: request.URL?.absoluteString ?? "",
			headers: request.allHTTPHeaderFields ?? [:],
			contentType: request.allHTTPHeaderFields?["Content-Type"] ?? "application/octet-stream",
			body: request.HTTPBody,
			deserializedBody: deserializedBody
		)
	}

	/// An unavailable initializer.
	@available(*, unavailable) override public init() {
		fatalError("\(#function) is not implemented.");
	}
	
}
