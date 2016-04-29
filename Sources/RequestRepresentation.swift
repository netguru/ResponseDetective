//
// RequestRepresentation.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// Represents a foundation URL request.
@objc(RDVRequestRepresentation) public final class RequestRepresentation: NSObject {
	
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
	
	/// Initializes the RequestRepresentation instance.
	///
	/// - Parameters:
	///     - request: The URL request instance.
	///     - identifier: A unique identifier of the request.
	public init(request: NSURLRequest, deserializedBody: String?, identifier: String) {
		self.method = request.HTTPMethod ?? "GET"
		self.URLString = request.URL?.absoluteString ?? ""
		self.headers = request.allHTTPHeaderFields ?? [:]
		self.contentType = self.headers["Content-Type"] ?? "application/octet-stream"
		self.body = request.HTTPBody
		self.deserializedBody = deserializedBody
		self.identifier = identifier
	}
	
	/// An unavailable initializer.
	@available(*, unavailable) public override init() {
		fatalError("\(#function) is not implemented.");
	}
	
}
