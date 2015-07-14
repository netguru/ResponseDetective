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
					// TODO: implement tests
				}
				
				it("should register response interceptor properly") {

				}
				
				it("should register error interceptor properly") {

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
