//
// ErrorRepresentation.swift
//
// Copyright © 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// Represents an instance of `NSError`.
@objc(RDTErrorRepresentation) public final class ErrorRepresentation: NSObject {

	// MARK: Initializers

	/// Initializes the receiver.
	///
	/// - Parameters:
	///     - requestIdentifier: The request's unique identifier.
	///     - response: The HTTP URL response representation, if any.
	///     - domain: The error domain.
	///     - code: The error code.
	///     - reason: The error reason.
	///     - userInfo: The error user info.
	public init(requestIdentifier: String, response: ResponseRepresentation?, domain: String, code: Int, reason: String, userInfo: [String: Any]) {
		self.requestIdentifier = requestIdentifier
		self.response = response
		self.domain = domain
		self.code = code
		self.reason = reason
		self.userInfo = userInfo
	}
	
	/// Initializes the receiver.
	///
	/// - Parameters:
	///     - requestIdentifier: The unique identifier of assocciated request.
	///     - error: The error that came with the response.
	///     - response: The HTTP URL response representation, if any.
	public convenience init(requestIdentifier: String, error: NSError, response: ResponseRepresentation?) {
		self.init(
			requestIdentifier: requestIdentifier,
			response: response,
			domain: error.domain,
			code: error.code,
			reason: error.localizedDescription,
			userInfo: error.userInfo as? [String: AnyObject] ?? [:]
		)
	}

	// MARK: Properties
	
	/// The request's unique identifier.
	public let requestIdentifier: String
	
	/// The response representation that came along with the error.
	public let response: ResponseRepresentation?
	
	/// The error domain.
	public let domain: String
	
	/// The error code.
	public let code: Int
	
	/// The error reason.
	public let reason: String
	
	/// The error user info.
	public let userInfo: [String: Any]

	// MARK: Unavailable
	
	/// An unavailable initializer.
	@available(*, unavailable) public override init() {
		fatalError("\(#function) is not implemented.");
	}
	
}
