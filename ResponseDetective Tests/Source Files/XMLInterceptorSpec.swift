//
//
//  XMLInterceptorSpec.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Nimble
import ResponseDetective
import Quick


class XMLInterceptorSpec: QuickSpec {
	
	override func spec() {
		
		describe("XMLInterceptor") {
			
			var stream: BufferOutputStream!
			var sut: XMLInterceptor!

			let uglyFixtureString = "<foo>\t<bar baz=\"qux\">lorem ipsum</bar\n></foo>"
			let uglyFixtureData = uglyFixtureString.dataUsingEncoding(NSUTF8StringEncoding)!
			let prettyFixtureString = "<?xml version=\"1.0\"?>\n<foo>\n  <bar baz=\"qux\">lorem ipsum</bar>\n</foo>"

			let fixtureRequest = RequestRepresentation( {
				var mutableRequest = NSMutableURLRequest()
				mutableRequest.URL = NSURL(string: "https://httpbin.org/post")!
				mutableRequest.HTTPMethod = "POST"
				mutableRequest.addValue("application/xml", forHTTPHeaderField: "Content-Type");
				mutableRequest.HTTPBody = uglyFixtureData
				return mutableRequest
			}())!

			let fixtureResponse = ResponseRepresentation(NSHTTPURLResponse(
				URL: NSURL(string: "https://httpbin.org/post")!,
				statusCode: 200,
				HTTPVersion: "HTTP/1.1",
				headerFields: [
					"Content-Type": "text/xml"
				]
			)!, uglyFixtureData)!

			beforeEach {
				stream = BufferOutputStream()
				sut = XMLInterceptor(outputStream: stream)
			}

			it("should be able to intercept application/xml requests") {
				expect(sut.canInterceptRequest(fixtureRequest)).to(beTrue())
			}

			it("should be able to intercept text/xml responses") {
				expect(sut.canInterceptResponse(fixtureResponse)).to(beTrue())
			}

			it("should output a correct string when intercepting a application/xml request") {
				sut.interceptRequest(fixtureRequest)
				expect(stream.buffer).toEventually(contain(prettyFixtureString), timeout: 2, pollInterval: 0.5)
			}

			it("should output a correct string when intercepting a text/xml response") {
				sut.interceptResponse(fixtureResponse)
				expect(stream.buffer).toEventually(contain(prettyFixtureString), timeout: 2, pollInterval: 0.5)
			}

		}
		
	}

}
