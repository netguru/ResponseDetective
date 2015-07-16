//
//
//  XMLInterceptorSpec.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Nimble
import ResponseDetective
import Quick


class InterceptingProtocolSpec: QuickSpec {
	
	override func spec() {
		
		let fixtureRequestInterceptor = TestRequestInterceptor()
		let fixtureResponseInterceptor = TestResponseInterceptor()
		let fixtureErrorInterceptor = TestErrorInterceptor()
		
		describe("Intercepting protocol") {
			
			afterEach() {
				InterceptingProtocol.unregisterAllRequestInterceptors()
				InterceptingProtocol.unregisterAllResponseInterceptors()
				InterceptingProtocol.unregisterAllErrorInterceptors()
			}
			
			context("registering interceptors") {
				
				it("should register request interceptor properly") {
					InterceptingProtocol.registerRequestInterceptor(fixtureRequestInterceptor)
					let isContainingInterceptor = InterceptingProtocol.requestInterceptors.filter( {
						interceptor in interceptor === fixtureRequestInterceptor
					}).count > 0
					expect(isContainingInterceptor).to(beTrue())
				}
				
				it("should register response interceptor properly") {
					InterceptingProtocol.registerResponseInterceptor(fixtureResponseInterceptor)
					let isContainingInterceptor = InterceptingProtocol.responseInterceptors.filter( {
						interceptor in interceptor === fixtureResponseInterceptor
					}).count > 0
					expect(isContainingInterceptor).to(beTrue())
				}
				
				it("should register error interceptor properly") {
					InterceptingProtocol.registerErrorInterceptor(fixtureErrorInterceptor)
					let isContainingInterceptor = InterceptingProtocol.errorInterceptors.filter( {
						interceptor in interceptor === fixtureErrorInterceptor
					}).count > 0
					expect(isContainingInterceptor).to(beTrue())
				}
			}
			
			context("unregistering interceptors") {
			
				it("should unregister request interceptor properly") {
					InterceptingProtocol.registerRequestInterceptor(fixtureRequestInterceptor)
					InterceptingProtocol.unregisterRequestInterceptor(fixtureRequestInterceptor)
					let isContainingInterceptor = InterceptingProtocol.responseInterceptors.filter( {
						interceptor in interceptor === fixtureRequestInterceptor
					}).count > 0
					expect(isContainingInterceptor).to(beFalse())
				}
				
				it("should unregister response interceptor properly") {
					InterceptingProtocol.registerResponseInterceptor(fixtureResponseInterceptor)
					InterceptingProtocol.unregisterResponseInterceptor(fixtureResponseInterceptor)
					let isContainingInterceptor = InterceptingProtocol.responseInterceptors.filter( {
						interceptor in interceptor === fixtureResponseInterceptor
					}).count > 0
					expect(isContainingInterceptor).to(beFalse())
				}
				
				it("should unregister error interceptor properly") {
					InterceptingProtocol.registerErrorInterceptor(fixtureErrorInterceptor)
					InterceptingProtocol.unregisterErrorInterceptor(fixtureErrorInterceptor)
					let isContainingInterceptor = InterceptingProtocol.errorInterceptors.filter( {
						interceptor in interceptor === fixtureErrorInterceptor
					}).count > 0
					expect(isContainingInterceptor).to(beFalse())
				}
			}
		}
	}
}
