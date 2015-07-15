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
					let token = InterceptingProtocol.registerRequestInterceptor(fixtureRequestInterceptor)
					let interceptor = InterceptingProtocol.requestInterceptors[token]
					expect(interceptor === fixtureRequestInterceptor).to(beTrue())
				}
				
				it("should register response interceptor properly") {
					let token = InterceptingProtocol.registerResponseInterceptor(fixtureResponseInterceptor)
					let interceptor = InterceptingProtocol.responseInterceptors[token]
					expect(interceptor === fixtureResponseInterceptor).to(beTrue())
				}
				
				it("should register error interceptor properly") {
					let token = InterceptingProtocol.registerErrorInterceptor(fixtureErrorInterceptor)
					let interceptor = InterceptingProtocol.errorInterceptors[token]
					expect(interceptor === fixtureErrorInterceptor).to(beTrue())
				}
			}
			
			context("unregistering interceptors") {
			
				it("should unregister request interceptor properly") {
					let token = InterceptingProtocol.registerRequestInterceptor(fixtureRequestInterceptor)
					InterceptingProtocol.unregisterRequestInterceptor(token)
					expect(InterceptingProtocol.requestInterceptors[token]).to(beNil())
				}
				
				it("should unregister response interceptor properly") {
					let token = InterceptingProtocol.registerResponseInterceptor(fixtureResponseInterceptor)
					InterceptingProtocol.unregisterResponseInterceptor(token)
					expect(InterceptingProtocol.responseInterceptors[token]).to(beNil())
				}
				
				it("should unregister error interceptor properly") {
					let token = InterceptingProtocol.registerErrorInterceptor(fixtureErrorInterceptor)
					InterceptingProtocol.unregisterErrorInterceptor(token)
					expect(InterceptingProtocol.errorInterceptors[token]).to(beNil())
				}
			}
		}
	}
}
