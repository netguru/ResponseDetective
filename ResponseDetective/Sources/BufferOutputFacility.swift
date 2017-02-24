//
// BufferOutputFacility.swift
//
// Copyright © 2016-2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// An output facility that adds received representations to array buffers.
@objc(RDTBufferOutputFacility) public final class BufferOutputFacility: NSObject, OutputFacility {

	// MARK: Properties

	/// A buffer of request representations.
	public private(set) var requestRepresentations: [RequestRepresentation] = []

	/// A buffer of request representations.
	public private(set) var responseRepresentations: [ResponseRepresentation] = []

	/// A buffer of request representations.
	public private(set) var errorRepresentations: [ErrorRepresentation] = []

	// MARK: OutputFacility

	/// Adds the request representation to the buffer.
	///
	/// - SeeAlso: OutputFacility.output(requestRepresentation:)
	public func output(requestRepresentation request: RequestRepresentation) {
		requestRepresentations.append(request)
	}
	
	/// Adds the response representation to the buffer.
	///
	/// - SeeAlso: OutputFacility.output(responseRepresentation:)
	public func output(responseRepresentation response: ResponseRepresentation) {
		responseRepresentations.append(response)
	}
	
	/// Adds the error representation to the buffer.
	///
	/// - SeeAlso: OutputFacility.output(errorRepresentation:)
	public func output(errorRepresentation error: ErrorRepresentation) {
		errorRepresentations.append(error)
	}

}
