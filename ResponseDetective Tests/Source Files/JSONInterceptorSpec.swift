//
//  JSONInterceptorSpec.swift
//  
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

class JSONInterceptorSpec: QuickSpec {

	override func spec() {

		describe("JSONInterceptor") {

			var stream: BufferOutputStream!
			var sut: JSONInterceptor!

			let uglyFixtureString = "{\"foo\":\"bar\"\n,\"baz\":true }"
			let uglyFixtureData = uglyFixtureString.dataUsingEncoding(NSUTF8StringEncoding)!
			let prettyFixtureString = "{\n  \"foo\" : \"bar\",\n  \"baz\" : true\n}"

			let fixtureRequest = RequestRepresentation( {
				let mutableRequest = NSMutableURLRequest()
				mutableRequest.URL = NSURL(string: "https://httpbin.org/post")!
				mutableRequest.HTTPMethod = "POST"
				mutableRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
				mutableRequest.HTTPBody = uglyFixtureData
				return mutableRequest
			}())!

			let fixtureResponse = ResponseRepresentation(NSHTTPURLResponse(
				URL: NSURL(string: "https://httpbin.org/post")!,
				statusCode: 200,
				HTTPVersion: "HTTP/1.1",
				headerFields: [
					"Content-Type": "application/json"
				]
			)!, uglyFixtureData)!

			beforeEach {
				stream = BufferOutputStream()
				sut = JSONInterceptor(outputStream: stream)
			}

			it("should be able to intercept application/json requests") {
				expect(sut.canInterceptRequest(fixtureRequest)).to(beTrue())
			}

			it("should be able to intercept application/json responses") {
				expect(sut.canInterceptResponse(fixtureResponse)).to(beTrue())
			}

			it("should output a correct string when intercepting a application/json request") {
				sut.interceptRequest(fixtureRequest)
				expect(stream.buffer).toEventually(contain(prettyFixtureString), timeout: 2, pollInterval: 0.5)
			}

			it("should output a correct string when intercepting a application/json response") {
				sut.interceptResponse(fixtureResponse)
				expect(stream.buffer).toEventually(contain(prettyFixtureString), timeout: 2, pollInterval: 0.5)
			}

		}

	}
	
}
