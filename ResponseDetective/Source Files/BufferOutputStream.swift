//
//  BufferOutputStream.swift
//  
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

/// An output stream which adds its data to a buffer array.
@objc(RDVBufferOutputStream) public final class BufferOutputStream: OutputStreamType {

	/// The buffer array containing all the messages.
	public private(set) var buffer: [String] = []

	// MARK: Initialization

	/// Initializes the receiver.
	public init() {}

	// MARK: OutputStreamType implementation

	public func write(string: String) {
		buffer.append(string)
	}
	
}
