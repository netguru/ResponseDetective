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

internal final class JSONBodyDeserializerSpec: QuickSpec {
	
	override func spec() {
		
		describe("JSONBodyDeserializer") {

			let sut = JSONBodyDeserializer()

			it("should correctly deserialize JSON data") {
                let source: [String: Any] = ["foo": "", "bar": 0, "baz": false, "qux": [AnyObject](), "corge": [String: Any]()]
				let data = try! JSONSerialization.data(withJSONObject: source, options: [])
				let expected = try! String(data: JSONSerialization.data(withJSONObject: source, options: [.prettyPrinted]), encoding: .utf8)!
                
				expect { sut.deserializeBody(data) }.to(equal(expected))
			}
			
		}
		
	}
	
}
