//
//  DummySpec.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Nimble
import Quick

class MathSpec: QuickSpec { override func spec() {

	describe("math") {

		it("is awesome") {
			expect(2+3).to(equal(5))
		}

	}

}}
