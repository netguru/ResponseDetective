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

final class HTMLBodyDeserializerSpec: QuickSpec {

	override func spec() {

		describe("HTMLBodyDeserializer") {

			var sut: HTMLBodyDeserializer! = nil

			beforeEach {
				sut = HTMLBodyDeserializer()
			}

			it("should correctly deserialize xml data") {
				let source = "<html><head></head><body class=\"foo\"><p>lorem<br>ipsum</p></body></html>"
				let data = (source as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
				let expected = "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\">\n<html>\n<head></head>\n<body class=\"foo\"><p>lorem<br>ipsum</p></body>\n</html>"
				expect { sut.deserializeBody(data) }.to(equal(expected))
			}

		}
		
	}
	
}