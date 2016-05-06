//
// PlaintextBodyDeserializerSpec.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

final class PlaintextBodyDeserializerSpec: QuickSpec {
	
	override func spec() {
		
		describe("PlaintextBodyDeserializer") {

			var sut: PlaintextBodyDeserializer! = nil

			beforeEach {
				sut = PlaintextBodyDeserializer()
			}

			it("should correctly deserialize JSON data") {
				let source = "foo bar\nbaz qux"
				let data = (source as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
				let expected = source
				expect { sut.deserializeBody(data) }.to(equal(expected))
			}
			
		}
		
	}
	
}
