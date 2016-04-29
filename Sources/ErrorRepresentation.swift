//
// ErrorRepresentation.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// Represents a foundation response error.
@objc(RDVErrorRepresentation) public final class ErrorRepresentation: NSObject {
	
	/// The request's unique identifier.
	public let requestIdentifier: String
	
	/// The response representation that came along with the error.
	public let response: ResponseRepresentation?
	
	/// The error domain.
	public let domain: String
	
	/// The error code.
	public let code: Int
	
	/// The error reason.
	public let reason: String?
	
	/// The error user info.
	public let userInfo: [String: NSObject]
	
	/// Initializes the ErrorRepresentation instance.
	///
	/// - Parameters:
	///     - response: The HTTP URL response representation, if any.
	///     - error: The error that came with the response.
	///     - requestIdentifier: The unique identifier of assocciated request.
	public init(response: ResponseRepresentation?, error: NSError, requestIdentifier: String) {
		self.response = response
		self.domain = error.domain
		self.code = error.code
		self.reason = error.localizedDescription
		self.userInfo = error.userInfo as? [String: NSObject] ?? [:]
		self.requestIdentifier = requestIdentifier
	}
	
	/// An unavailable initializer.
	@available(*, unavailable) public override init() {
		fatalError("\(#function) is not implemented.");
	}
	
}
