//
//  JSONBodyDeserializer.swift
//
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//
//  Licensed under the MIT License.
//

import Foundation

/// Deserializes JSON bodies.
@objc(RDVJSONBodyDeserializer) public final class JSONBodyDeserializer: NSObject, BodyDeserializer {
	
	/// Deserializes JSON data into a pretty-printed string.
	public func deserializeBody(body: NSData) throws -> String {
		let object = try NSJSONSerialization.JSONObjectWithData(body, options: [])
		let data = try NSJSONSerialization.dataWithJSONObject(object, options: [.PrettyPrinted])
		return NSString(data: data, encoding: NSUTF8StringEncoding)! as String
	}
	
}
