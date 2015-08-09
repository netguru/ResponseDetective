//
//  NSLogOutputStream.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/// An output stream which prints its data right to the console using
/// Foundation's NSLog function. This stream might be used instead of Println
/// stream if you'd like your messages to appear in Apple System Log as well.
@objc(RDVNSLogOutputStream) public final class NSLogOutputStream: OutputStreamType {

	// MARK: OutputStreamType implementation

	public func write(string: String) {
		NSLog("%@", string)
	}
	
}
