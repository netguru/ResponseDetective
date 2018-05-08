//
// ConsoleOutputFacilitySpec.swift
//
// Copyright © 2016-2017 Netguru Sp. z o.o. All rights reserved.
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

			it("should produce correct string request output") {
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
			
			it("should produce correct image request output") {
				let request = RequestRepresentation(
					identifier: "0",
					method: "GET",
					urlString: "http://foo.bar",
					headers: ["X-Foo": "bar"],
					body: UIImageJPEGRepresentation(UIImage.size(CGSize(width: 5.0, height: 10.0)), 1.0),
					deserializedBody: nil
				)
				let expected = "<0> [REQUEST] GET http://foo.bar\n" +
				               " ├─ Headers\n" +
				               " │ X-Foo: bar\n" +
				               " ├─ Body\n" +
				               " │ <5px × 10px image>\n"
				sut.output(requestRepresentation: request)
				expect(buffer.last).to(equal(expected))
			}
			
			it("should produce correct data request output") {
				let body = "Hello World".data(using: .utf8)!
				let request = RequestRepresentation(
					identifier: "0",
					method: "GET",
					urlString: "http://foo.bar",
					headers: ["X-Foo": "bar"],
					body: body,
					deserializedBody: nil
				)
				let expected = "<0> [REQUEST] GET http://foo.bar\n" +
				               " ├─ Headers\n" +
				               " │ X-Foo: bar\n" +
				               " ├─ Body\n" +
				               " │ <unrecognizable \(body.count) bytes>\n"
				sut.output(requestRepresentation: request)
				expect(buffer.last).to(equal(expected))
			}
			
			it("should produce correct empty request output") {
				let request = RequestRepresentation(
					identifier: "0",
					method: "GET",
					urlString: "http://foo.bar",
					headers: ["X-Foo": "bar"],
					body: nil,
					deserializedBody: nil
				)
				let expected = "<0> [REQUEST] GET http://foo.bar\n" +
				               " ├─ Headers\n" +
				               " │ X-Foo: bar\n" +
				               " ├─ Body\n" +
				               " │ <empty>\n"
				sut.output(requestRepresentation: request)
				expect(buffer.last).to(equal(expected))
			}
			
			it("should produce correct string response output") {
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
			
			it("should produce correct image response output") {
				let response = ResponseRepresentation(
					requestIdentifier: "0",
					statusCode: 200,
					urlString: "http://foo.bar",
					headers: ["X-Bar": "foo"],
					body: UIImageJPEGRepresentation(UIImage.size(CGSize(width: 5.0, height: 10.0)), 1.0),
					deserializedBody: nil
				)
				let expected = "<0> [RESPONSE] 200 (NO ERROR) http://foo.bar\n" +
				               " ├─ Headers\n" +
				               " │ X-Bar: foo\n" +
				               " ├─ Body\n" +
				               " │ <5px × 10px image>\n"
				sut.output(responseRepresentation: response)
				expect(buffer.last).to(equal(expected))
			}
			
			it("should produce correct data response output") {
				let body = "Hello World".data(using: .utf8)!
				let response = ResponseRepresentation(
					requestIdentifier: "0",
					statusCode: 200,
					urlString: "http://foo.bar",
					headers: ["X-Bar": "foo"],
					body: body,
					deserializedBody: nil
				)
				let expected = "<0> [RESPONSE] 200 (NO ERROR) http://foo.bar\n" +
				               " ├─ Headers\n" +
				               " │ X-Bar: foo\n" +
				               " ├─ Body\n" +
				               " │ <unrecognizable \(body.count) bytes>\n"
				sut.output(responseRepresentation: response)
				expect(buffer.last).to(equal(expected))
			}
			
			it("should produce correct empty response output") {
				let response = ResponseRepresentation(
					requestIdentifier: "0",
					statusCode: 200,
					urlString: "http://foo.bar",
					headers: ["X-Bar": "foo"],
					body: nil,
					deserializedBody: nil
				)
				let expected = "<0> [RESPONSE] 200 (NO ERROR) http://foo.bar\n" +
				               " ├─ Headers\n" +
				               " │ X-Bar: foo\n" +
				               " ├─ Body\n" +
				               " │ <empty>\n"
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

internal extension UIImage {
	
	/// Initializes a new `UIImage`.
	/// - parameter size: The desired size.
	/// - returns: The `UIImage` with the desired size.
	internal class func size(_ size: CGSize) -> UIImage {
		let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
		UIGraphicsBeginImageContext(rect.size)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image!
	}
	
}
