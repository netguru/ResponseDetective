//
//  InterceptingProtocolSpec.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Nimble
import ResponseDetective
import Quick


class InterceptingProtocolSpec: QuickSpec {
	
	override func spec() {

		let sut = InterceptingProtocol.self
		
		let fixtureRequestInterceptor = TestRequestInterceptor()
		let fixtureResponseInterceptor = TestResponseInterceptor()
		let fixtureErrorInterceptor = TestErrorInterceptor()
		
		describe("InterceptingProtocol") {
			
			afterEach() {
				InterceptingProtocol.unregisterAllRequestInterceptors()
				InterceptingProtocol.unregisterAllResponseInterceptors()
				InterceptingProtocol.unregisterAllErrorInterceptors()
			}
			
			describe("registering interceptors") {
				
				it("should register request interceptor properly") {
					InterceptingProtocol.registerRequestInterceptor(fixtureRequestInterceptor)
					expect(contains(InterceptingProtocol.requestInterceptors, {
						$0 === fixtureRequestInterceptor
					})).to(beTrue())
				}
				
				it("should register response interceptor properly") {
					InterceptingProtocol.registerResponseInterceptor(fixtureResponseInterceptor)
					expect(contains(InterceptingProtocol.responseInterceptors, {
						$0 === fixtureResponseInterceptor
					})).to(beTrue())
				}
				
				it("should register error interceptor properly") {
					InterceptingProtocol.registerErrorInterceptor(fixtureErrorInterceptor)
					expect(contains(InterceptingProtocol.errorInterceptors, {
						$0 === fixtureErrorInterceptor
					})).to(beTrue())
				}
			}
			
			context("unregistering interceptors") {
			
				it("should unregister request interceptor properly") {
					InterceptingProtocol.registerRequestInterceptor(fixtureRequestInterceptor)
					InterceptingProtocol.unregisterRequestInterceptor(fixtureRequestInterceptor)
					expect(contains(InterceptingProtocol.requestInterceptors, {
						$0 === fixtureRequestInterceptor
					})).to(beFalse())
				}
				
				it("should unregister response interceptor properly") {
					InterceptingProtocol.registerResponseInterceptor(fixtureResponseInterceptor)
					InterceptingProtocol.unregisterResponseInterceptor(fixtureResponseInterceptor)
					expect(contains(InterceptingProtocol.responseInterceptors, {
						$0 === fixtureResponseInterceptor
					})).to(beFalse())
				}
				
				it("should unregister error interceptor properly") {
					InterceptingProtocol.registerErrorInterceptor(fixtureErrorInterceptor)
					InterceptingProtocol.unregisterErrorInterceptor(fixtureErrorInterceptor)
					expect(contains(InterceptingProtocol.errorInterceptors, {
						$0 === fixtureErrorInterceptor
					})).to(beFalse())
				}
			}
		}
	}
}
