//
// XMLBodyDeserializerSpec.swift
//
// Copyright © 2016-2020 Netguru S.A. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
import Nimble
import ResponseDetective
#if SWIFT_PACKAGE
import ResponseDetectiveObjC
#endif
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
