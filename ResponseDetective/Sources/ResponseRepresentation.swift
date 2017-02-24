//
// ResponseRepresentation.swift
//
// Copyright © 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// Represents a pair of `HTTPURLResponse` and `Data` instances.
@objc(RDTResponseRepresentation) public final class ResponseRepresentation: NSObject {

	// MARK: Initializers

	/// Initializes the receiver.
	///
	/// - Parameters:
	///     - requestIdentifier: The request's unique identifier.
	///     - statusCode: The status code of the response.
	///     - urlString: The URL string of the response.
	///     - headers: The HTTP headers of the response.
	///     - body: The raw body data of the response.
	///     - deserializedBody: The parsed body of the response.
	public init(requestIdentifier: String, statusCode: Int, urlString: String, headers: [String: String], body: Data?, deserializedBody: String?) {
		self.requestIdentifier = requestIdentifier
		self.statusCode = statusCode
		self.urlString = urlString
		self.headers = headers
		self.body = body
		self.deserializedBody = deserializedBody
	}
	
	/// Initializes the receiver.
	///
	/// - Parameters:
	///     - requestIdentifier: The unique identifier of assocciated request.
	///     - response: The HTTP URL response instance.
	///     - body: The body that came with the response.
	///     - deserializedBody: The deserialized response body.
	public convenience init(requestIdentifier: String, response: HTTPURLResponse, body: Data?, deserializedBody: String?) {
		self.init(
			requestIdentifier: requestIdentifier,
			statusCode: response.statusCode,
			urlString: response.url?.absoluteString ?? "",
			headers: response.allHeaderFields as? [String: String] ?? [:],
			body: body,
			deserializedBody: deserializedBody
		)
	}

	// MARK: Properties
	
	/// The request's unique identifier.
	public let requestIdentifier: String
	
	/// The status code of the response.
	public let statusCode: Int
	
	/// A verbal representation of the status code.
	public var statusString: String {
		return HTTPURLResponse.localizedString(forStatusCode: statusCode)
	}
	
	/// The URL string of the response (which may be different than originally
	/// requested because of a redirect).
	public let urlString: String
	
	/// The HTTP headers of the response.
	public let headers: [String: String]
	
	/// The content type of the response.
	public var contentType: String {
		return headers["Content-Type"] ?? "application/octet-stream"
	}
	
	/// The raw body data of the response.
	public let body: Data?
	
	/// The parsed body of the response.
	public let deserializedBody: String?
	
}
