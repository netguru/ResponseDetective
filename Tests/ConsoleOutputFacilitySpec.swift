//
// ConsoleOutputFacilitySpec.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
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
					URLString: "http://foo.bar",
					headers: [
						"X-Foo": "bar",
						"X-Baz": "qux",
					],
					body: nil,
					deserializedBody: "lorem ipsum"
				)
				let expected = "<0> [REQUEST] GET http://foo.bar\n" +
				               " ├─ Headers\n" +
				               " │ X-Foo: bar\n" +
				               " │ X-Baz: qux\n" +
				               " ├─ Body\n" +
				               " │ lorem ipsum\n"
				sut.outputRequestRepresentation(request)
				expect(buffer.last).to(equal(expected))
			}

			it("should produce correct response output") {
				let response = ResponseRepresentation(
					requestIdentifier: "0",
					statusCode: 200,
					URLString: "http://foo.bar",
					headers: [
						"X-Bar": "foo",
						"X-Qux": "baz",
					],
					body: nil,
					deserializedBody: "dolor sit amet"
				)
				let expected = "<0> [RESPONSE] 200 (NO ERROR) http://foo.bar\n" +
				               " ├─ Headers\n" +
				               " │ X-Bar: foo\n" +
							   " │ X-Qux: baz\n" +
				               " ├─ Body\n" +
				               " │ dolor sit amet\n"
				sut.outputResponseRepresentation(response)
				expect(buffer.last).to(equal(expected))
			}

			it("should produce correct error ourput") {
				let error = ErrorRepresentation(
					requestIdentifier: "0",
					response: nil,
					domain: "foo.bar.error",
					code: 1234,
					reason: "just because",
					userInfo: [
						"foo": "bar",
						"baz": "qux",
					]
				)
				let expected = "<0> [ERROR] foo.bar.error 1234\n" +
				               " ├─ User Info\n" +
				               " │ baz: qux\n" +
				               " │ foo: bar\n"
				sut.outputErrorRepresentation(error)
				expect(buffer.last).to(equal(expected))
			}

		}
		
	}
	
}
