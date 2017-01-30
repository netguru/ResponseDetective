//
// XMLBodyDeserializerSpec.swift
//
// Copyright (c) 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

internal final class XMLBodyDeserializerSpec: QuickSpec {

	override func spec() {

		describe("XMLBodyDeserializer") {

			let sut = XMLBodyDeserializer()

			it("should correctly deserialize XML data") {
				let source = "<foo bar=\"baz\"><qux></qux></foo>"
				let data = source.data(using: .utf8)!
				let expected = "<?xml version=\"1.0\"?>\n<foo bar=\"baz\">\n  <qux/>\n</foo>"
				expect { sut.deserialize(body: data) }.to(equal(expected))
			}

		}

	}
	
}
