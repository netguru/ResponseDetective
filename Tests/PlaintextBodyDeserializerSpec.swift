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

internal final class PlaintextBodyDeserializerSpec: QuickSpec {
	
	override func spec() {
		
		describe("PlaintextBodyDeserializer") {

			let sut = PlaintextBodyDeserializer()

			it("should correctly deserialize plaintext data") {
				let source = "foo bar\nbaz qux"
				let data = (source as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
				let expected = source
				expect { sut.deserializeBody(data) }.to(equal(expected))
			}
			
		}
		
	}
	
}
