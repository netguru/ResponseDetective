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
							guard let subject = subject as? NSURLRequest, let URL = subject.URL, let string = URL.absoluteString else {
								return true
							}
							return string.containsString("foo")
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
							TestBodyDeserializer(fixedDeserializedBody: "lorem ipsum"),
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
							TestBodyDeserializer(fixedDeserializedBody: "dolor sit amet"),
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

			describe("request interception") {

				let buffer = BufferOutputFacility()
				let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()

				beforeEach {
					ResponseDetective.outputFacility = buffer
					ResponseDetective.registerBodyDeserializer(TestBodyDeserializer(), forContentType: "*/*")
					ResponseDetective.enableInURLSessionConfiguration(configuration)
				}

				context("before request has been sent") {

					it("should intercept no requests") {
						expect(buffer.requestRepresentations).to(beEmpty())
					}

				}

				context("after request has been sent") {

					let request: NSURLRequest = {
						let request = NSMutableURLRequest()
						request.URL = NSURL(string: "https://httpbin.org/post")!
						request.HTTPMethod = "POST"
						request.HTTPBody = NSData(base64EncodedString: "foo", options: [])
						return request
					}()

					beforeEach {
						let session = NSURLSession(configuration: configuration)
						session.dataTaskWithRequest(request).resume()
					}

					it("should eventually intercept it") {
						expect(buffer.requestRepresentations.count).toEventually(beGreaterThanOrEqualTo(1), timeout: 5.0)
						expect(buffer.responseRepresentations.last?.body).toEventuallyNot(beNil())
					}

				}

			}

			describe("response interception") {

				let buffer = BufferOutputFacility()
				let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()

				beforeEach {
					ResponseDetective.outputFacility = buffer
					ResponseDetective.registerBodyDeserializer(TestBodyDeserializer(), forContentType: "*/*")
					ResponseDetective.enableInURLSessionConfiguration(configuration)
				}

				context("before request has been sent") {

					it("should intercept no responses") {
						expect(buffer.responseRepresentations).to(beEmpty())
					}

				}

				context("after request has been sent") {

					let request = NSURLRequest(URL: NSURL(string: "https://httpbin.org/get")!)

					beforeEach {
						let session = NSURLSession(configuration: configuration)
						session.dataTaskWithRequest(request).resume()
					}

					it("should eventually intercept its response") {
						expect(buffer.responseRepresentations.count).toEventually(beGreaterThanOrEqualTo(1), timeout: 5.0)
					}

				}

			}

			describe("error interception") {

				let buffer = BufferOutputFacility()
				let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()

				beforeEach {
					ResponseDetective.outputFacility = buffer
					ResponseDetective.registerBodyDeserializer(TestBodyDeserializer(), forContentType: "*/*")
					ResponseDetective.enableInURLSessionConfiguration(configuration)
				}

				context("before request has been sent") {

					it("should intercept no errors") {
						expect(buffer.responseRepresentations).to(beEmpty())
					}

				}

				context("after request has been sent") {

					let request = NSURLRequest(URL: NSURL(string: "https://foobar")!)

					beforeEach {
						let session = NSURLSession(configuration: configuration)
						session.dataTaskWithRequest(request).resume()
					}

					it("should eventually intercept its error") {
						expect(buffer.errorRepresentations.count).toEventually(beGreaterThanOrEqualTo(1), timeout: 5.0)
					}

				}

			}
			
		}

	}

}
