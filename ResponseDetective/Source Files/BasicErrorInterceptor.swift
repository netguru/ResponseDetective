//
//  BasicErrorInterceptor.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// A basic error interceptor which writes the error into the given stream.
public final class BasicErrorInterceptor: ErrorInterceptorType {

	/// The output stream used by the interceptor.
	public private(set) var outputStream: OutputStreamType

	// MARK: Initialization

	/// Initializes the interceptor with a output stream.
	///
	/// :param: outputStream The output stream to be used.
	public init(outputStream: OutputStreamType) {
		self.outputStream = outputStream
	}

	/// Initializes the interceptor with a Println output stream.
	public convenience init() {
		self.init(outputStream: PrintlnOutputStream())
	}

	// MARK: ErrorInterceptorType implementation

	public func interceptError(error: NSError, _ response: ResponseRepresentation?) {
		outputStream.write(error.description)
	}

}
