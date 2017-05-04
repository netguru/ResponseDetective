//
// URLEncodedBodyDeserializerSpec.swift
//
// Copyright © 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

internal final class URLEncodedBodyDeserializerSpec: QuickSpec {

	override func spec() {

		describe("URLEncodedBodyDeserializer") {

			let sut = URLEncodedBodyDeserializer()

			it("should correctly deserialize URL-encoded data") {

				if #available(macOS 10.10, *) {

					let items = [URLQueryItem(name: "foo", value: nil), URLQueryItem(name: "bar", value: "baz")]
					let components = URLComponents(queryItems: items)
					let data = components.url!.relativeString.data(using: .utf8)!

					let actualString = sut.deserialize(body: data)
					let expectedString = "foo: nil\nbar: baz"

					expect(actualString).to(equal(expectedString))

				} else {

					let expectedString = "foo&bar=baz"
					let actualString = sut.deserialize(body: expectedString.data(using: .utf8)!)

					expect(actualString).to(equal(expectedString))

				}

			}

		}
		
	}
	
}

// MARK: -

@available(macOS 10.10, *) fileprivate extension URLComponents {

	fileprivate init(queryItems: [URLQueryItem]) {
		self.init()
		self.queryItems = queryItems
	}

}
