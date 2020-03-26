//
// RequestRepresentationSpec.swift
//
// Copyright © 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

internal final class RequestRepresentationSpec: QuickSpec {

	override func spec() {

		describe("RequestRepresentation") {

			context("after initializing with a request") {

				let fixtureRequest = NSMutableURLRequest(
					URL: URL(string: "https://httpbin.org/post")!,
					HTTPMethod: "POST",
					headerFields: [
						"Content-Type": "application/json",
						"X-Foo": "bar",
					],
					HTTPBody: try! JSONSerialization.data(withJSONObject: ["foo": "bar"], options: [])
				)

				let fixtureIdentifier = "1"

				var sut: RequestRepresentation!

				beforeEach {
					sut = RequestRepresentation(identifier: fixtureIdentifier, request: fixtureRequest as URLRequest, deserializedBody: nil)
				}

				it("should have a correct identifier") {
					expect(sut.identifier).to(equal(fixtureIdentifier))
				}

				it("should have a correct URLString") {
					expect(sut.urlString).to(equal(fixtureRequest.url!.absoluteString))
				}

				it("should have a correct method") {
					expect(sut.method).to(equal(fixtureRequest.httpMethod))
				}

				it("should have correct headers") {
					expect(sut.headers).to(equal(fixtureRequest.allHTTPHeaderFields))
				}

				it("should have a correct body") {
					expect(sut.body).to(equal(fixtureRequest.httpBody))
				}

			}

		}

	}

}

private extension NSMutableURLRequest {

	convenience init(URL: Foundation.URL, HTTPMethod: String, headerFields: [String: String], HTTPBody: Data?) {
		self.init(url: URL)
		self.httpMethod = HTTPMethod
		self.allHTTPHeaderFields = headerFields
		self.httpBody = HTTPBody
	}

}
