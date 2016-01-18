//
//  ResponseRepresentation.swift
//
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//
//  Licensed under the MIT License.
//

import Foundation

/// Represents a foundation URL response.
@objc(RDVResponseRepresentation) public final class ResponseRepresentation: NSObject {
	
	/// The request's unique identifier.
	public let requestIdentifier: String
	
	/// The status code of the response.
	public let statusCode: Int
	
	/// A verbal representation of the status code.
	public let statusString: String
	
	/// The URL string of the response (which may be different than originally
	/// requested because of a redirect).
	public let URLString: String
	
	/// The HTTP headers of the response.
	public let headers: [String: String]
	
	/// The content type of the response.
	public let contentType: String
	
	/// The raw body data of the response.
	public let body: NSData?
	
	/// The parsed body of the response.
	public let deserializedBody: String?
	
	/// Initializes the RequestRepresentation instance.
	///
	/// - Parameters:
	///     - response: The HTTP URL response instance.
	///     - body: The body that came with the response.
	///     - requestIdentifier: The unique identifier of assocciated request.
	///
	/// - Returns: An initialized instance of the receiver.
	public init(response: NSHTTPURLResponse, body: NSData?, deserializedBody: String?, requestIdentifier: String) {
		self.statusCode = response.statusCode
		self.statusString = NSHTTPURLResponse.localizedStringForStatusCode(self.statusCode)
		self.URLString = response.URL?.absoluteString ?? ""
		self.headers = response.allHeaderFields as? [String: String] ?? [:]
		self.contentType = self.headers["ContentType"] ?? "application/octet-stream"
		self.body = body
		self.deserializedBody = deserializedBody
		self.requestIdentifier = requestIdentifier
	}
	
	/// An unavailable initializer.
	@available(*, unavailable) public override init() {
		fatalError("\(__FUNCTION__) is not implemented.");
	}
	
}
