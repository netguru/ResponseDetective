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

internal final class ResponseRepresentationSpec: QuickSpec {
	
	override func spec() {
		
		describe("ResponseRepresentation") {
			
			context("after initializing with a response") {
				
				let fixtureResponse = HTTPURLResponse(
					url: URL(string: "https://httpbin.org/post")!,
					statusCode: 200,
					httpVersion: nil,
					headerFields: [
						"Content-Type": "application/json",
						"X-Foo": "bar"
					]
				)!
				
				let fixtureBody = try! JSONSerialization.data(withJSONObject: ["foo": "bar"], options: [])
				let fixtureIdentifier = "1"
				
				var sut: ResponseRepresentation!
				
				beforeEach {
					sut = ResponseRepresentation(requestIdentifier: fixtureIdentifier, response: fixtureResponse, body: fixtureBody, deserializedBody: nil)
				}
				
				it("should have a correct identifier") {
					expect(sut.requestIdentifier).to(equal(fixtureIdentifier))
				}
				
				it("should have a correct URLString") {
					expect(sut.URLString).to(equal(fixtureResponse.url!.absoluteString))
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
