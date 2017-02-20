//
// RequestRepresentation.swift
//
// Copyright © 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// Represents an instance of `URLRequest`.
@objc(RDTRequestRepresentation) public final class RequestRepresentation: NSObject {

	// MARK: Initializers

	/// Initializes the receiver.
	///
	/// - Parameters:
	///     - identifier: A unique identifier of the request.
	///     - method: he HTTP method of the request.
	///     - urlString: The resolved URL string of the request.
	///     - headers: The HTTP headers of the request.
	///     - body: The raw body data of the request.
	///     - deserializedBody: The parsed body of the request.
	public init(identifier: String, method: String, urlString: String, headers: [String: String], body: Data?, deserializedBody: String?) {
		self.identifier = identifier
		self.method = method
		self.urlString = urlString
		self.headers = headers
		self.body = body
		self.deserializedBody = deserializedBody
	}

	/// Initializes the receiver.
	///
	/// - Parameters:
	///     - identifier: A unique identifier of the request.
	///     - request: The URL request instance.
	///     - deserializedBody: The parsed body of the request.
	public convenience init(identifier: String, request: URLRequest, deserializedBody: String?) {
		self.init(
			identifier: identifier,
			method: request.httpMethod ?? "GET",
			urlString: request.url?.absoluteString ?? "",
			headers: request.allHTTPHeaderFields ?? [:],
			body: request.httpBody,
			deserializedBody: deserializedBody
		)
	}

	// MARK: Properties
	
	/// A unique identifier of the request.
	public let identifier: String
	
	/// The HTTP method of the request.
	public let method: String
	
	/// The resolved URL string of the request.
	public let urlString: String
	
	/// The HTTP headers of the request.
	public let headers: [String: String]
	
	/// The content type of the request.
	public var contentType: String {
		return headers["Content-Type"] ?? "application/octet-stream"
	}
	
	/// The raw body data of the request.
	public let body: Data?
	
	/// The parsed body of the request.
	public let deserializedBody: String?

}
