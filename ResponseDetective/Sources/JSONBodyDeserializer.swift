//
// JSONBodyDeserializer.swift
//
// Copyright © 2016-2020 Netguru S.A. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
#if SWIFT_PACKAGE
import ResponseDetectiveObjC
#endif

/// Deserializes JSON bodies.
@objc(RDTJSONBodyDeserializer) public final class JSONBodyDeserializer: NSObject, BodyDeserializer {

	// MARK: BodyDeserializer

	/// Deserializes JSON data into a pretty-printed string.
	public func deserialize(body: Data) -> String? {
		do {
			let object = try JSONSerialization.jsonObject(with: body, options: [])
			let data = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
			return String(data: data, encoding: .utf8)
		} catch {
			return nil
		}
	}

}
