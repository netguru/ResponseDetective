//
//  ResponseDetective.swift
//
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//
//  Licensed under the MIT License.
//

import Foundation

@objc(RDVResponseDetective) public final class ResponseDetective: NSObject {
	
	/// An output facility for reporting requests, responses and errors.
	public let outputFacility: OutputFacility
	
	/// A URL protocol instance to be injected into URL sessions.
	public let URLProtocol: NSURLProtocol
	
	/// A URL session delegate to be injected into URL sessions.
	public let URLSessionDelegate: NSURLSessionDelegate
	
	/// Initializes the ResponseDetective instance.
	///
	/// - Parameters:
 	///     - outputFacility: An output facility.
	///
	/// - Returns: An initialized instance of the receiver.
	public init(outputFacility: OutputFacility) {
		self.outputFacility = outputFacility;
	}
	
	/// Initializes the ResponseDetective instance with a default configuration.
	///
	/// - Returns: An initialized instance of the receiver.
	public override convenience init() {
		self.init(outputFacility: ConsoleOutputFacility())
	}
	
}
