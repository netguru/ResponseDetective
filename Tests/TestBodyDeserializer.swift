//
// TestBodyDeserializer.swift
//
// Copyright (c) 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import ResponseDetective

/// A test body deserializer.
internal final class TestBodyDeserializer: NSObject, BodyDeserializer {

	/// The closure for deserializing bodies.
	let deserializationClosure: @convention(block) (Data) -> String?

	/// Creates a general deserializer with given deserialization closure.
	///
	/// - Parameter deserializationClosure: Implementation of `deserializeBody`.
	internal init(deserializationClosure: @escaping @convention(block) (Data) -> String?) {
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
		self.init { String(data: $0, encoding: .utf8) as String? }
	}

	// MARK: Implementation

	/// - SeeAlso: BodyDeserializer.deserializeBody(_:)
	internal func deserialize(body data: Data) -> String? {
		return deserializationClosure(data)
	}

}
