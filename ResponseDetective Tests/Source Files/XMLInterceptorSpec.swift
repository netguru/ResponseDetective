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
			
			beforeEach {
				stream = BufferOutputStream()
				sut = XMLInterceptor(outputStream: stream)
			}
			
			it("should be able to intercept xml requests") {
				let request = RequestRepresentation({
					var mutableRequest = NSMutableURLRequest()
					mutableRequest.URL = NSURL(string: "https://httpbin.org/get")!
					mutableRequest.addValue("application/xml", forHTTPHeaderField: "Content-Type");
					return mutableRequest
					}())!
				expect(sut.canInterceptRequest(request)).to(beTrue())
			}
			
			it("should be able to intercept xml responses") {
				let response = ResponseRepresentation(NSHTTPURLResponse(
					URL: NSURL(string: "https://httpbin.org/get")!,
					statusCode: 200,
					HTTPVersion: "HTTP/1.1",
					headerFields: [
						"Content-Type": "application/xml"
					]
					)!, nil)!
				expect(sut.canInterceptResponse(response)).to(beTrue())
			}
		}
	}

}
