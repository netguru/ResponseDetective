//
//  BaseInterceptorSpec.swift
//  
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

class BaseInterceptorSpec: QuickSpec {

	override func spec() {

		describe("BaseInterceptor") {

			var stream: BufferOutputStream!
			var sut: BaseInterceptor!

			let fixtureRequestURLString = "https://httpbin.org/post"
			let fixtureRequestMethod = "POST"
			let fixtureRequestHeaders = ["X-Foo": "bar"]
			let fixtureRequestHeadersString = "X-Foo: bar"

			let fixtureResponseURLString = "https://httpbin.org/post"
			let fixtureResponseStatusCode = 200
			let fixtureResponseStatusCodeString = "no error"
			let fixtureResponseHeaders = ["X-Foo": "bar"]
			let fixtureResponseHeadersString = "X-Foo: bar"

			let fixtureRequest = RequestRepresentation( {
				var mutableRequest = NSMutableURLRequest()
				mutableRequest.URL = NSURL(string: fixtureRequestURLString)!
				mutableRequest.HTTPMethod = fixtureRequestMethod
				for (field, value) in fixtureRequestHeaders {
					mutableRequest.setValue(value, forHTTPHeaderField: field)
				}
				return mutableRequest
			}())!

			let fixtureResponse = ResponseRepresentation(NSHTTPURLResponse(
				URL: NSURL(string: fixtureResponseURLString)!,
				statusCode: fixtureResponseStatusCode,
				HTTPVersion: "HTTP/1.1",
				headerFields: fixtureResponseHeaders
			)!, nil)!

			beforeEach {
				stream = BufferOutputStream()
				sut = BaseInterceptor(outputStream: stream)
			}

			it("should be able to intercept any request") {
				expect(sut.canInterceptRequest(fixtureRequest)).to(beTrue())
			}

			it("should be able to intercept any response") {
				expect(sut.canInterceptResponse(fixtureResponse)).to(beTrue())
			}

			it("should output correct strings when intercepting any request") {
				sut.interceptRequest(fixtureRequest)
				expect(stream.buffer).toEventually(contain("\(fixtureRequestMethod) \(fixtureRequestURLString)"), timeout: 2, pollInterval: 0.5)
				expect(stream.buffer).toEventually(contain(fixtureRequestHeadersString), timeout: 2, pollInterval: 0.5)
			}

			it("should output correct strings when intercepting any response") {
				sut.interceptResponse(fixtureResponse)
				expect(stream.buffer).toEventually(contain("\(fixtureResponseStatusCode) \(fixtureResponseStatusCodeString)"), timeout: 2, pollInterval: 0.5)
				expect(stream.buffer).toEventually(contain(fixtureResponseHeadersString), timeout: 2, pollInterval: 0.5)
			}
			
		}
		
	}
	
}
