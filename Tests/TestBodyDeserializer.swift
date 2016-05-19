//
// TestBodyDeserializer.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import ResponseDetective

internal final class TestBodyDeserializer: NSObject, BodyDeserializer {

	private let deserializedBody: String?

	internal init(deserializedBody: String?) {
		self.deserializedBody = deserializedBody
	}

	internal func deserializeBody(data: NSData) -> String? {
		return deserializedBody
	}

}
