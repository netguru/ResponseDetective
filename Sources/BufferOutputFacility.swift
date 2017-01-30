//
// BufferOutputFacility.swift
//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import Foundation

/// An output facility that adds received representations to array buffers.
@objc(RDTBufferOutputFacility) public final class BufferOutputFacility: NSObject, OutputFacility {

	/// A buffer of request representations.
	public private(set) var requestRepresentations: [RequestRepresentation] = []

	/// A buffer of request representations.
	public private(set) var responseRepresentations: [ResponseRepresentation] = []

	/// A buffer of request representations.
	public private(set) var errorRepresentations: [ErrorRepresentation] = []

	/// Adds the request representation to the buffer.
	///
	/// - SeeAlso: OutputFacility.outputRequestRepresentation
	public func outputRequestRepresentation(_ request: RequestRepresentation) {
		requestRepresentations.append(request)
	}
	
	/// Adds the response representation to the buffer.
	///
	/// - SeeAlso: OutputFacility.outputResponseRepresentation
	public func outputResponseRepresentation(_ response: ResponseRepresentation) {
		responseRepresentations.append(response)
	}
	
	/// Adds the error representation to the buffer.
	///
	/// - SeeAlso: OutputFacility.outputErrorRepresentation
	public func outputErrorRepresentation(_ error: ErrorRepresentation) {
		errorRepresentations.append(error)
	}

}
