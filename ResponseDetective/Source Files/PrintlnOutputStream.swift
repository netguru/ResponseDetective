//
//  PrintlnOutputStream.swift
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

/// A simple output stream which prints its data right to the console using
/// stdlib's println function.
@objc(RDVPrintlnOutputStream) public final class PrintlnOutputStream: OutputStreamType {

	// MARK: OutputStreamType implementation

	public func write(string: String) {
		println(string)
	}

}
