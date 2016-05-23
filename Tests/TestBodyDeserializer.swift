//
// TestBodyDeserializer.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import ResponseDetective

/// A test body deserializer.
internal final class TestBodyDeserializer: NSObject, BodyDeserializer {

	/// The closure for deserializing bodies.
	let deserializationClosure: @convention(block) (NSData) -> String?

	/// Creates a general deserializer with given deserialization closure.
	///
	/// - Parameter deserializationClosure: Implementation of `deserializeBody`.
	internal init(deserializationClosure: @convention(block) (NSData) -> String?) {
		self.deserializationClosure = deserializationClosure
	}

	/// Creates a deserializer with fixed deserialized body.
	///
	/// - Parameter fixedDeserializedBody: A fixed deserialized body.
	internal convenience init(fixedDeserializedBody: String?) {
		self.init { _ in fixedDeserializedBody }
	}

	/// Creates a deserializer which deserializes data into plaintext.
	internal convenience override init() {
		self.init { NSString(data: $0, encoding: NSUTF8StringEncoding) as String? }
	}

	// MARK: Implementation

	/// - SeeAlso: BodyDeserializer.deserializeBody(_:)
	internal func deserializeBody(data: NSData) -> String? {
		return deserializationClosure(data)
	}

}
