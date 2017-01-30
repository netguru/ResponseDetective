//
// JSONBodyDeserializerSpec.swift
//
// Copyright (c) 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

internal final class JSONBodyDeserializerSpec: QuickSpec {
	
	override func spec() {
		
		describe("JSONBodyDeserializer") {

			let sut = JSONBodyDeserializer()

			it("should correctly deserialize JSON data") {
				let source: [String: Any] = ["foo": "", "bar": 0, "baz": false, "qux": [AnyObject](), "corge": [String: Any]()]
				let data = try! JSONSerialization.data(withJSONObject: source, options: [])
				let actualData = sut.deserialize(body: data)!.data(using: .utf8)!
				let actualJSON = try! JSONSerialization.jsonObject(with: actualData, options: []) as! [String: Any]

				expect { (actualJSON as NSDictionary) }.to(equal(source as NSDictionary))
			}
			
		}
		
	}
	
}
