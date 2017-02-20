//
// BufferOutputFacilitySpec.swift
//
// Copyright © 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

internal final class BufferOutputFacilitySpec: QuickSpec {

	override func spec() {

		describe("BufferOutputFacility") {

			let sut = BufferOutputFacility()

			it("should buffer request representations") {
				let request = RequestRepresentation(
					identifier: "0",
					method: "GET",
					urlString: "http://foo.bar",
					headers: [
						"X-Foo": "bar",
						"X-Baz": "qux",
					],
					body: nil,
					deserializedBody: "lorem ipsum"
				)
				sut.output(requestRepresentation: request)
				expect(sut.requestRepresentations.count).to(beGreaterThanOrEqualTo(1))
			}

			it("should buffer response representation") {
				let response = ResponseRepresentation(
					requestIdentifier: "0",
					statusCode: 200,
					urlString: "http://foo.bar",
					headers: [
						"X-Bar": "foo",
						"X-Qux": "baz",
					],
					body: nil,
					deserializedBody: "dolor sit amet"
				)
				sut.output(responseRepresentation: response)
				expect(sut.responseRepresentations.count).to(beGreaterThanOrEqualTo(1))
			}

			it("should buffer error representations") {
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
				sut.output(errorRepresentation: error)
				expect(sut.errorRepresentations.count).to(beGreaterThanOrEqualTo(1))
			}

		}

	}

}
