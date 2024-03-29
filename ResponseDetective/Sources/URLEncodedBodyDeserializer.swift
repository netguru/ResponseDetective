//
// URLEncodedBodyDeserializer.swift
//
// Copyright © 2016-2020 Netguru S.A. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
#if SWIFT_PACKAGE
import ResponseDetectiveObjC
#endif

/// Deserializes URL-encoded bodies.
@objc(RDTURLEncodedBodyDeserializer) public final class URLEncodedBodyDeserializer: NSObject, BodyDeserializer {

	// MARK: BodyDeserializer

	/// Deserializes JSON data into a pretty-printed string.
	public func deserialize(body: Data) -> String? {

		guard let string = String(data: body, encoding: .utf8) else {
			return nil
		}

		if #available(macOS 10.10, *) {

			let stringFromQueryItems: ([URLQueryItem]) -> String = {
				$0.map { "\($0.name): \($0.value ?? "nil")" }.joined(separator: "\n")
			}

			if let items = URLComponents(string: string)?.queryItems {
				return stringFromQueryItems(items)
			}

			if let items = URLComponents(string: "?\(string)")?.queryItems {
				return stringFromQueryItems(items)
			}

		}

		return string

	}

}
