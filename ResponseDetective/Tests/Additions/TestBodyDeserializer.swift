//
// TestBodyDeserializer.swift
//
// Copyright © 2016-2020 Netguru S.A. All rights reserved.
// Licensed under the MIT License.
//

import ResponseDetective
#if SWIFT_PACKAGE
import ResponseDetectiveObjC
#endif

/// A test body deserializer.
internal final class TestBodyDeserializer: NSObject, BodyDeserializer {
    
    // MARK: Nested types
    
    public typealias DeserializationClosure = (Data) -> String?
    
	/// The closure for deserializing bodies.
	let deserializationClosure: DeserializationClosure

	/// Creates a general deserializer with given deserialization closure.
	///
	/// - Parameter deserializationClosure: Implementation of `deserializeBody`.
	internal init(deserializationClosure: @escaping DeserializationClosure) {
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
