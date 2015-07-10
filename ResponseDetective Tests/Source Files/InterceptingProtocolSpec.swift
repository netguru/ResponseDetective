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
				InterceptingProtocol.clearInterceptors()
			}
			
			context("registering interceptors") {
				
				it("should register request interceptor properly") {
					let removalToken = InterceptingProtocol.registerRequestInterceptor(fixtureRequestInterceptor)
					expect(removalToken).to(equal(1))
				}
				
				it("should register response interceptor properly") {
					let removalToken = InterceptingProtocol.registerResponseInterceptor(fixtureResponseInterceptor)
					expect(removalToken).to(equal(1))
				}
				
				it("should register error interceptor properly") {
					let removalToken = InterceptingProtocol.registerErrorInterceptor(fixtureErrorInterceptor)
					expect(removalToken).to(equal(1))
				}
			}
			
			context("unregistering interceptors") {
			
				it("should unregister request interceptor properly") {

				}
				
				it("should unregister request interceptor properly") {

				}
				
				it("should unregister request interceptor properly") {

					
				}
				
			}
			
		}
	}
}
