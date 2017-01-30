//
// ResponseDetectiveSpec.swift
//
// Copyright (c) 2016-2017 Netguru Sp. z o.o. All rights reserved.
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
					expect(type(of: ResponseDetective.outputFacility) == ConsoleOutputFacility.self).to(beTruthy())
				}

				it("should use default url protocol class") {
					expect(ResponseDetective.URLProtocolClass).to(beIdenticalTo(NSClassFromString("RDTURLProtocol")!))
				}

			}

			describe("enabling in url session configuration") {

				let configuration = URLSessionConfiguration.default

				beforeEach {
					ResponseDetective.enableInURLSessionConfiguration(configuration)
				}

				it("should add protocol class at the beginning of array") {
					expect(configuration.protocolClasses!.first == ResponseDetective.URLProtocolClass).to(beTrue())
				}

			}

			describe("ignoring requests") {

				let request = URLRequest(url: URL(string: "http://foo.bar")!)

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
							guard let subject = subject as? URLRequest, let url = subject.url else {
								return true
							}
							let string = url.absoluteString
                            
							return string.contains("foo")
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
							ResponseDetective.deserializeBody(Data(), contentType: "foo/bar")
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
							ResponseDetective.deserializeBody(Data(), contentType: "foo/bar")
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
							ResponseDetective.deserializeBody(Data(), contentType: "foo/baz")
						}.to(equal("dolor sit amet"))
					}

				}

			}

			describe("request interception") {

				let buffer = BufferOutputFacility()
				let configuration = URLSessionConfiguration.default

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

					let request: URLRequest = {
						var request = URLRequest(url: URL(string: "https://httpbin.org/post")!)
						request.httpMethod = "POST"
						request.httpBody = Data(base64Encoded: "foo", options: [])
						return request
					}()

					beforeEach {
						let session = URLSession(configuration: configuration)
						session.dataTask(with: request).resume()
					}

					it("should eventually intercept it") {
						expect(buffer.requestRepresentations.count).toEventually(beGreaterThanOrEqualTo(1), timeout: 5.0)
						expect(buffer.responseRepresentations.last?.body).toEventuallyNot(beNil(), timeout: 5.0)
					}

				}

			}

			describe("response interception") {

				let buffer = BufferOutputFacility()
				let configuration = URLSessionConfiguration.default

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

					let request = URLRequest(url: URL(string: "https://httpbin.org/get")!)

					beforeEach {
						let session = URLSession(configuration: configuration)
						session.dataTask(with: request).resume()
					}

					it("should eventually intercept its response") {
						expect(buffer.responseRepresentations.count).toEventually(beGreaterThanOrEqualTo(1), timeout: 5.0)
					}

				}

			}

			describe("error interception") {

				let buffer = BufferOutputFacility()
				let configuration = URLSessionConfiguration.default

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

					let request = URLRequest(url: URL(string: "https://foobar")!)

					beforeEach {
						let session = URLSession(configuration: configuration)
						session.dataTask(with: request).resume()
					}

					it("should eventually intercept its error") {
						expect(buffer.errorRepresentations.count).toEventually(beGreaterThanOrEqualTo(1), timeout: 5.0)
					}

				}

			}
			
		}

	}

}
