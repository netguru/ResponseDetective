//
// ConsoleOutputFacilitySpec.swift
//
// Copyright (c) 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

internal final class ConsoleOutputFacilitySpec: QuickSpec {

	override func spec() {

		describe("ConsoleOutputFacility") {

			var buffer = [String]()
			let sut = ConsoleOutputFacility(printClosure: { buffer.append($0) })

			it("should produce correct request output") {
				let request = RequestRepresentation(
					identifier: "0",
					method: "GET",
					urlString: "http://foo.bar",
					headers: ["X-Foo": "bar"],
					body: nil,
					deserializedBody: "lorem ipsum"
				)
				let expected = "<0> [REQUEST] GET http://foo.bar\n" +
				               " ├─ Headers\n" +
				               " │ X-Foo: bar\n" +
				               " ├─ Body\n" +
				               " │ lorem ipsum\n"
				sut.output(requestRepresentation: request)
				expect(buffer.last).to(equal(expected))
			}

			it("should produce correct response output") {
				let response = ResponseRepresentation(
					requestIdentifier: "0",
					statusCode: 200,
					urlString: "http://foo.bar",
					headers: ["X-Bar": "foo"],
					body: nil,
					deserializedBody: "dolor sit amet"
				)
				let expected = "<0> [RESPONSE] 200 (NO ERROR) http://foo.bar\n" +
				               " ├─ Headers\n" +
				               " │ X-Bar: foo\n" +
				               " ├─ Body\n" +
				               " │ dolor sit amet\n"
				sut.output(responseRepresentation: response)
				expect(buffer.last).to(equal(expected))
			}

			it("should produce correct error ourput") {
				let error = ErrorRepresentation(
					requestIdentifier: "0",
					response: nil,
					domain: "foo.bar.error",
					code: 1234,
					reason: "just because",
					userInfo: ["foo": "bar"]
				)
				let expected = "<0> [ERROR] foo.bar.error 1234\n" +
				               " ├─ User Info\n" +
				               " │ foo: bar\n"
				sut.output(errorRepresentation: error)
				expect(buffer.last).to(equal(expected))
			}

		}
		
	}
	
}
