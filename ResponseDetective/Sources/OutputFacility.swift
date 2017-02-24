//
// OutputFacility.swift
//
// Copyright © 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// Represents an output facility which is capable of displaying requests,
/// responses and errors.
@objc(RDTOutputFacility) public protocol OutputFacility {
	
	/// Outputs a request representation.
	///
	/// - Parameters:
	///     - request: The request representation to output.
	@objc(outputRequestRepresentation:) func output(requestRepresentation request: RequestRepresentation)
	
	/// Outputs a response representation.
	///
	/// - Parameters:
	///     - response: The response representation to output.
	@objc(outputResponseRepresentation:) func output(responseRepresentation response: ResponseRepresentation)
	
	/// Outputs an error representation.
	///
	/// - Parameters:
	///     - error: The error representation to output.
	@objc(outputErrorRepresentation:) func output(errorRepresentation error: ErrorRepresentation)
	
}
