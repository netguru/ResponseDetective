//
//  OutputStreamType.swift
//  
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

/// A target of text streaming operations.
public protocol OutputStreamType {
	
	/// Append the given string to this stream.
	///
	/// - parameter string: The string to append.
	func write(string: String)
	
}
