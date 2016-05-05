//
// PlaintextBodyDeserializer.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// Deserializes plaintext bodies.
@objc(RDTPlaintextBodyDeserializer) public final class PlaintextBodyDeserializer: NSObject, BodyDeserializer {

	/// Deserializes plaintext data into a string.
	public func deserializeBody(body: NSData) -> String? {
		return NSString(data: body, encoding: NSUTF8StringEncoding) as String?
	}

}
