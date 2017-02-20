//
// PlaintextBodyDeserializer.swift
//
// Copyright © 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// Deserializes plaintext bodies.
@objc(RDTPlaintextBodyDeserializer) public final class PlaintextBodyDeserializer: NSObject, BodyDeserializer {

	// MARK: BodyDeserializer

	/// Deserializes plaintext data into a string.
	public func deserialize(body: Data) -> String? {
		return NSString(data: body, encoding: String.Encoding.utf8.rawValue) as String?
	}

}
