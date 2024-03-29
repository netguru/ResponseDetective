//
// ResponseDetectiveSpec.swift
//
// Copyright © 2016-2020 Netguru S.A. All rights reserved.
// Licensed under the MIT License.
//

import Foundation
import Nimble
import OHHTTPStubs
import ResponseDetective
import Quick

internal final class ResponseDetectiveSpec: QuickSpec {

	override func spec() {

		describe("ResponseDetective") {

			beforeSuite {
				HTTPStubs.stubRequests { request in
					return request.url?.host == "httpbin.org"
				} withStubResponse: { _ in
					return HTTPStubsResponse(data: Data(), statusCode: 200, headers: nil)
				}
			}

			beforeEach {
				ResponseDetective.reset()
			}

			afterSuite {
				HTTPStubs.removeAllStubs()
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
					ResponseDetective.enable(inConfiguration: configuration)
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
							ResponseDetective.canIncercept(request: request)
						}.to(beTruthy())
					}

				}

				context("after adding predicate") {

					beforeEach {
						ResponseDetective.ignoreRequests(matchingPredicate: NSPredicate { subject, _ in
							guard let subject = subject as? URLRequest, let url = subject.url else {
								return true
							}
							let string = url.absoluteString

							return string.contains("foo")
						})
					}

					it("should ignore the request") {
						expect {
							ResponseDetective.canIncercept(request: request)
						}.to(beFalsy())
					}

				}

			}

			describe("body deserialization") {

				context("before registering a custom body deserializer") {

					it("should return no deserialized body") {
						expect {
							ResponseDetective.deserialize(body: Data(), contentType: "foo/bar")
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

					it("should return a deserialized body") {
						expect {
							ResponseDetective.deserialize(body: Data(), contentType: "foo/bar")
						}.to(equal("lorem ipsum"))
					}

					it("should return a deserialized body for content type containing properties") {
						expect {
							ResponseDetective.deserialize(body: Data(), contentType: "foo/bar; charset=utf8")
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

					it("should return a deserialized body") {
						expect {
							ResponseDetective.deserialize(body: Data(), contentType: "foo/baz")
						}.to(equal("dolor sit amet"))
					}

				}

			}

			describe("request interception") {

				var buffer: BufferOutputFacility!
				let configuration = URLSessionConfiguration.default

				beforeEach {
					buffer = BufferOutputFacility()
					ResponseDetective.outputFacility = buffer
					ResponseDetective.registerBodyDeserializer(TestBodyDeserializer(), forContentType: "*/*")
					ResponseDetective.enable(inConfiguration: configuration)
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
						expect(buffer.requestRepresentations.count).toEventually(beGreaterThanOrEqualTo(1), timeout: .seconds(5))
						expect(buffer.responseRepresentations.last?.body).toEventuallyNot(beNil(), timeout: .seconds(5))
					}

				}

			}

			describe("response interception") {

				var buffer: BufferOutputFacility!
				let configuration = URLSessionConfiguration.default

				beforeEach {
					buffer = BufferOutputFacility()
					ResponseDetective.outputFacility = buffer
					ResponseDetective.registerBodyDeserializer(TestBodyDeserializer(), forContentType: "*/*")
					ResponseDetective.enable(inConfiguration: configuration)
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
						expect(buffer.responseRepresentations.count).toEventually(beGreaterThanOrEqualTo(1), timeout: .seconds(5))
					}

				}

			}

			describe("error interception") {

				var buffer: BufferOutputFacility!
				let configuration = URLSessionConfiguration.default

				beforeEach {
					buffer = BufferOutputFacility()
					ResponseDetective.outputFacility = buffer
					ResponseDetective.registerBodyDeserializer(TestBodyDeserializer(), forContentType: "*/*")
					ResponseDetective.enable(inConfiguration: configuration)
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
						expect(buffer.errorRepresentations.count).toEventually(beGreaterThanOrEqualTo(1), timeout: .seconds(5))
					}

				}

			}

		}

	}

}
