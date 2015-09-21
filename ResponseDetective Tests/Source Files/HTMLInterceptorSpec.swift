//
//  HTMLInterceptorSpec.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

class HTMLInterceptorSpec: QuickSpec {
	
	override func spec() {
		
		describe("HTMLInterceptor") {
			
			var stream: BufferOutputStream!
			var sut: HTMLInterceptor!

			let uglyFixtureString = "<!DOCTYPE html><p\nclass=\"foo\">bar<br></p>"
			let uglyFixtureData = uglyFixtureString.dataUsingEncoding(NSUTF8StringEncoding)!
			let prettyFixtureString = "<!DOCTYPE html>\n<html><body><p class=\"foo\">bar<br></p></body></html>"

			let fixtureRequest = RequestRepresentation( {
				let mutableRequest = NSMutableURLRequest()
				mutableRequest.URL = NSURL(string: "https://httpbin.org/post")!
				mutableRequest.HTTPMethod = "POST"
				mutableRequest.setValue("text/html", forHTTPHeaderField: "Content-Type")
				mutableRequest.HTTPBody = uglyFixtureData
				return mutableRequest
			}())!

			let fixtureResponse = ResponseRepresentation(NSHTTPURLResponse(
				URL: NSURL(string: "https://httpbin.org/post")!,
				statusCode: 200,
				HTTPVersion: "HTTP/1.1",
				headerFields: [
					"Content-Type": "text/html"
				]
			)!, uglyFixtureData)!

			beforeEach {
				stream = BufferOutputStream()
				sut = HTMLInterceptor(outputStream: stream)
			}

			it("should be able to intercept text/html requests") {
				expect(sut.canInterceptRequest(fixtureRequest)).to(beTrue())
			}

			it("should be able to intercept text/html responses") {
				expect(sut.canInterceptResponse(fixtureResponse)).to(beTrue())
			}

			it("should output a correct string when intercepting a text/html request") {
				sut.interceptRequest(fixtureRequest)
				expect(stream.buffer).toEventually(contain(prettyFixtureString), timeout: 2, pollInterval: 0.5)
			}

			it("should output a correct string when intercepting a text/html response") {
				sut.interceptResponse(fixtureResponse)
				expect(stream.buffer).toEventually(contain(prettyFixtureString), timeout: 2, pollInterval: 0.5)
			}

		}
		
	}

}
