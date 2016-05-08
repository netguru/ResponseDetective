//
// ErrorRepresentationSpec.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

final class ErrorRepresentationSpec: QuickSpec {
	
	override func spec() {
		
		describe("ErrorRepresentation") {
			
			context("after initializing with an error") {
				
				let fixtureIdentifier = "1"
				
				let fixtureError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: [
					NSLocalizedDescriptionKey: "The connection failed because the device is not connected to the internet.",
					NSURLErrorKey: NSURL(string: "https://httpbin.org/post")!
				])
				
				let fixtureResponse = ResponseRepresentation(
					requestIdentifier: fixtureIdentifier,
					response: NSHTTPURLResponse(
						URL: NSURL(string: "https://httpbin.org/post")!,
						statusCode: 200,
						HTTPVersion: nil,
						headerFields: [
							"Content-Type": "application/json",
							"X-Foo": "bar"
						]
					)!,
					body: nil,
					deserializedBody: nil
				)
				
				var sut: ErrorRepresentation!
				
				beforeEach {
					sut = ErrorRepresentation(requestIdentifier: fixtureIdentifier, error: fixtureError, response: fixtureResponse)
				}
				
				it("should have a correct identifier") {
					expect(sut.requestIdentifier).to(equal(fixtureIdentifier))
				}
				
				it("should have a correct response") {
					expect(sut.response).to(beIdenticalTo(fixtureResponse))
				}
				
				it("should have a correct domain") {
					expect(sut.domain).to(equal(fixtureError.domain))
				}
				
				it("should have a correct code") {
					expect(sut.code).to(equal(fixtureError.code))
				}
				
				it("should have a correct reason") {
					expect(sut.reason).to(equal(fixtureError.localizedDescription))
				}
				
				it("should have correct user info") {
					expect(sut.userInfo as? [String: NSObject]).to(equal(fixtureError.userInfo as? [String: NSObject]))
				}
				
			}
			
		}
		
	}
	
}
