//
// ResponseRepresentationSpec.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

final private class ResponseRepresentationSpec: QuickSpec {
	
	override func spec() {
		
		describe("ResponseRepresentation") {
			
			context("after initializing with a response") {
				
				let fixtureResponse = NSHTTPURLResponse(
					URL: NSURL(string: "https://httpbin.org/post")!,
					statusCode: 200,
					HTTPVersion: nil,
					headerFields: [
						"Content-Type": "application/json",
						"X-Foo": "bar"
					]
				)!
				
				let fixtureBody = try! NSJSONSerialization.dataWithJSONObject(["foo": "bar"], options: [])
				let fixtureIdentifier = "1"
				
				var sut: ResponseRepresentation!
				
				beforeEach {
					sut = ResponseRepresentation(response: fixtureResponse, body: fixtureBody, deserializedBody: nil, requestIdentifier: fixtureIdentifier)
				}
				
				it("should have a correct identifier") {
					expect(sut.requestIdentifier).to(equal(fixtureIdentifier))
				}
				
				it("should have a correct URLString") {
					expect(sut.URLString).to(equal(fixtureResponse.URL!.absoluteString))
				}
				
				it("should have a correct method") {
					expect(sut.statusCode).to(equal(fixtureResponse.statusCode))
				}
				
				it("should have correct headers") {
					expect(sut.headers).to(equal(fixtureResponse.allHeaderFields as? [String: String]))
				}
				
				it("should have a correct body") {
					expect(sut.body).to(equal(fixtureBody))
				}
				
			}
			
		}
		
	}
	
}
