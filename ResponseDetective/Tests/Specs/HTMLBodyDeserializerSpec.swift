//
// HTMLBodyDeserializerSpec.swift
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

internal final class HTMLBodyDeserializerSpec: QuickSpec {

	override func spec() {

		describe("HTMLBodyDeserializer") {

			let sut = HTMLBodyDeserializer()

			it("should correctly deserialize HTML data") {
				let source = "<!DOCTYPE html><html><head></head><body class=\"foo\"><p>lorem<br>ipsum</p></body></html>"
				let data = source.data(using: .utf8)!
				let expected = "<!DOCTYPE html>\n<html>\n<head></head>\n<body class=\"foo\"><p>lorem<br>ipsum</p></body>\n</html>"
				expect { sut.deserialize(body: data) }.to(equal(expected))
			}

		}

	}

}
