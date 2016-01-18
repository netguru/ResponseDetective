//
//  HTTPBodyDeserializer.swift
//
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//
//  Licensed under the MIT License.
//

import Foundation

/// Represents a body deserializer which is able to deserialize raw body data
/// into a human-readable string which will be logged as the request's or
/// response's body.
@objc(RDVBodyDeserializer) public protocol BodyDeserializer {
	
	/// Deserializes the body.
	///
	/// - Parameters:
	///     - body: The HTTP body.
	///
	/// - Returns: A deserialized representation of the body.
	func deserializeBody(body: NSData) -> String?
	
}
