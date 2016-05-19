//
// ResponseDetectiveSpec.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
import Nimble
import ResponseDetective
import Quick

internal final class ResponseDetectiveSpec: QuickSpec {
	
	override func spec() {
		
		describe("ResponseDetective") {

			beforeEach {
				ResponseDetective.reset()
			}
			
			describe("initial state") {

				it("should use default output facility") {
					expect(ResponseDetective.outputFacility.dynamicType == ConsoleOutputFacility.self).to(beTruthy())
				}

				it("should use default url protocol class") {
					expect(ResponseDetective.URLProtocolClass).to(beIdenticalTo(NSClassFromString("RDTURLProtocol")!))
				}

			}

			describe("enabling in url session configuration") {

				let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()

				beforeEach {
					ResponseDetective.enableInURLSessionConfiguration(configuration)
				}

				it("should add protocol class at the beginning of array") {
					expect(configuration.protocolClasses).to(beginWith(ResponseDetective.URLProtocolClass))
				}

			}

			describe("ignoring requests") {

				let request = NSURLRequest(URL: NSURL(string: "http://foo.bar")!)

				context("before adding predicate") {

					it("should not ignore the request") {
						expect {
							ResponseDetective.canIncerceptRequest(request)
						}.to(beTruthy())
					}

				}

				context("after adding predicate") {

					beforeEach {
						ResponseDetective.ignoreRequestsMatchingPredicate(NSPredicate { subject, _ in
							guard let subject = subject as? NSURLRequest, let URL = subject.URL else {
								return true
							}
							return URL.absoluteString.containsString("foo")
						})
					}

					it("should ignore the request") {
						expect {
							ResponseDetective.canIncerceptRequest(request)
						}.to(beFalsy())
					}

				}

			}

			describe("body deserialization") {

				context("before registering a custom body deserializer") {

					it("should return no deserialized body") {
						expect {
							ResponseDetective.deserializeBody(NSData(), contentType: "foo/bar")
						}.to(beNil())
					}

				}

				context("after registering an explicit body deserializer") {

					beforeEach {
						ResponseDetective.registerBodyDeserializer(
							TestBodyDeserializer(deserializedBody: "lorem ipsum"),
							forContentType: "foo/bar"
						)
					}

					it("should return no deserialized body") {
						expect {
							ResponseDetective.deserializeBody(NSData(), contentType: "foo/bar")
						}.to(equal("lorem ipsum"))
					}

				}

				context("after registering a wildcard body deserializer") {

					beforeEach {
						ResponseDetective.registerBodyDeserializer(
							TestBodyDeserializer(deserializedBody: "dolor sit amet"),
							forContentType: "foo/*"
						)
					}

					it("should return no deserialized body") {
						expect {
							ResponseDetective.deserializeBody(NSData(), contentType: "foo/baz")
						}.to(equal("dolor sit amet"))
					}

				}

			}
			
		}

	}

}
