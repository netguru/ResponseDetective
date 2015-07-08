//
//  PlainTextInterceptorSpec.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

class PlainTextInterceptorSpec: QuickSpec {
	
	override func spec() {
		
		describe("PlainTextInterceptor") {
			
			var stream: BufferOutputStream!
			var sut: PlainTextInterceptor!
			
			let fixturePlainTextString = "foo-bar-baz"
			let fixturePlainTextData = fixturePlainTextString.dataUsingEncoding(NSUTF8StringEncoding)
			
			let fixtureRequest = RequestRepresentation( {
				var mutableRequest = NSMutableURLRequest()
				mutableRequest.URL = NSURL(string: "https://httpbin.org/get")!
				mutableRequest.addValue("text/plain", forHTTPHeaderField: "Content-Type");
				mutableRequest.HTTPBody = fixturePlainTextData
				return mutableRequest
			}())!

			let fixtureResponse = ResponseRepresentation(NSHTTPURLResponse(
				URL: NSURL(string: "https://httpbin.org/get")!,
				statusCode: 200,
				HTTPVersion: "HTTP/1.1",
				headerFields: [
					"Content-Type": "text/plain"
				]
			)!, fixturePlainTextData)!
			
			beforeEach {
				stream = BufferOutputStream()
				sut = PlainTextInterceptor(outputStream: stream)
			}
			
			it("should be able to intercept text/plain requests") {
				expect(sut.canInterceptRequest(fixtureRequest)).to(beTrue())
			}
			
			it("should be able to intercept text/plain responses") {
				expect(sut.canInterceptResponse(fixtureResponse)).to(beTrue())
			}
			
			it("should output a correct string when intercepting a text/plain request") {
				sut.interceptRequest(fixtureRequest)
				expect(stream.buffer).toEventually(contain(fixturePlainTextString), timeout: 2, pollInterval: 0.5)
			}
			
			it("should output a correct string when intercepting a text/plain response") {
				sut.interceptResponse(fixtureResponse)
				expect(stream.buffer).toEventually(equal([fixturePlainTextString]), timeout: 2, pollInterval: 0.5)
			}

		}
		
	}
}
