//
// JSONBodyDeserializerSpec.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

final class JSONBodyDeserializerSpec: QuickSpec {
	
	override func spec() {
		
		describe("JSONBodyDeserializer") {

			let sut = JSONBodyDeserializer()

			it("should correctly deserialize JSON data") {
				let source = ["foo": "", "bar": 0, "baz": false, "qux": [AnyObject](), "corge": [String: AnyObject]()]
				let data = try! NSJSONSerialization.dataWithJSONObject(source, options: [])
				let expected = try! NSString(data: NSJSONSerialization.dataWithJSONObject(source, options: [.PrettyPrinted]), encoding: NSUTF8StringEncoding)!
				expect { sut.deserializeBody(data) }.to(equal(expected))
			}
			
		}
		
	}
	
}
