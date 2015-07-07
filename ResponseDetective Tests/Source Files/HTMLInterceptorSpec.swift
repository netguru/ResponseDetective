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
			
			beforeEach {
				stream = BufferOutputStream()
				sut = HTMLInterceptor(outputStream: stream)
			}
			
			it("should be able to intercept html requests") {
				let request = RequestRepresentation({
					var mutableRequest = NSMutableURLRequest()
					mutableRequest.URL = NSURL(string: "https://httpbin.org/get")!
					mutableRequest.addValue("text/html", forHTTPHeaderField: "Content-Type");
					return mutableRequest
					}())!
				expect(sut.canInterceptRequest(request)).to(beTrue())
			}
			
			it("should be able to intercept html responses") {
				let response = ResponseRepresentation(NSHTTPURLResponse(
					URL: NSURL(string: "https://httpbin.org/get")!,
					statusCode: 200,
					HTTPVersion: "HTTP/1.1",
					headerFields: [
						"Content-Type": "text/html"
					]
					)!, nil)!
				expect(sut.canInterceptResponse(response)).to(beTrue())
			}
		}
	}

}
