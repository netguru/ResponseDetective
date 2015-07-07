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
			
			beforeEach {
				stream = BufferOutputStream()
				sut = PlainTextInterceptor(outputStream: stream)
			}
			
			it("should be able to intercept json requests") {
				let request = RequestRepresentation( {
					var mutableRequest = NSMutableURLRequest()
					mutableRequest.URL = NSURL(string: "https://httpbin.org/get")!
					mutableRequest.addValue("text/plain", forHTTPHeaderField: "Content-Type");
					return mutableRequest
					}())!
				expect(sut.canInterceptRequest(request)).to(beTrue())
			}
			
			it("should be able to intercept json responses") {
				let response = ResponseRepresentation(NSHTTPURLResponse(
					URL: NSURL(string: "https://httpbin.org/get")!,
					statusCode: 200,
					HTTPVersion: "HTTP/1.1",
					headerFields: [
						"Content-Type": "text/plain"
					]
					)!, nil)!
				expect(sut.canInterceptResponse(response)).to(beTrue())
			}
		}
	}
}
