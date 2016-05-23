//
//  HTMLBodyDeserializerSpec.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

internal final class HTMLBodyDeserializerSpec: QuickSpec {

	override func spec() {

		describe("HTMLBodyDeserializer") {

			let sut = HTMLBodyDeserializer()

			it("should correctly deserialize HTML data") {
				let source = "<!DOCTYPE html><html><head></head><body class=\"foo\"><p>lorem<br>ipsum</p></body></html>"
				let data = (source as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
				let expected = "<!DOCTYPE html>\n<html>\n<head></head>\n<body class=\"foo\"><p>lorem<br>ipsum</p></body>\n</html>"
				expect { sut.deserializeBody(data) }.to(equal(expected))
			}

		}
		
	}
	
}