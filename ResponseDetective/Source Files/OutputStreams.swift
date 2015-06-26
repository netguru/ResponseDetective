//
//  OutputStreams.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// An output stream which adds its data to a buffer array.
public final class BufferOutputStream: OutputStreamType {

	/// The buffer array containing all the messages.
	public private(set) var buffer: [String] = []

	// MARK: OutputStreamType implementation

	public func write(string: String) {
		buffer.append(string)
	}

}

// MARK: -

/// An output stream which prints its data right to the console using
/// Foundation's NSLog function. This stream might be used instead of Println
/// stream if you'd like your messages to appear in Apple System Log as well.
public struct NSLogOutputStream: OutputStreamType {

	// MARK: OutputStreamType implementation

	public func write(string: String) {
		NSLog("%@", string)
	}

}

// MARK: -

/// A simple output stream which prints its data right to the console using
/// stdlib's println function.
public struct PrintlnOutputStream: OutputStreamType {

	// MARK: OutputStreamType implementation

	public func write(string: String) {
		println(string)
	}
	
}
